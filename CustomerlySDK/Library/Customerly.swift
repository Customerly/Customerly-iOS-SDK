//
//  Customerly.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/10/16.
//
//

import Kingfisher

public typealias SuccessResponse = ((_ newSurvey: Bool, _ newMessage: Bool) -> Void)

open class Customerly: NSObject {
    
    open static let sharedInstance = Customerly()
    var customerlySecretKey : String = ""
    var customerlyIsOpen = false
    
    /**
     Enable verbose logging, that is useful for debugging. By default is disabled.
     */
    open var verboseLogging : Bool = false
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    //MARK: - Configuration
    @objc open func configure(secretKey: String, widgetColor: UIColor? = nil){
        customerlySecretKey = secretKey
        user_color_template = widgetColor
        
        //Image cache expiration after one day
        ImageCache.default.maxCachePeriodInSecond = 86400
        
        //If user is not stored, ping ghost, else ping registered. Connect to socket
        ping(success: { () in
            CySocket.sharedInstance.configure()
            CySocket.sharedInstance.openConnection()
            cyPrint("Success Configure")
        })
        
        realTimeMessages { (message) in
            guard Customerly.sharedInstance.customerlyIsOpen != true else {
                return
            }
            let banner = CyBanner(name: message?.account?.name, attributedSubtitle: message?.content?.attributedStringFromHTML(font: UIFont(name: "Helvetica", size: 14.0)!, color:  UIColor(hexString: "#666666")), image: nil)
            banner.viewBanner?.avatarImageView?.kf.setImage(with: adminImageURL(id: message?.account_id, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            banner.show(didTapBlock: {
               self.openSupportConversationOnChat(message: message)
            })
        }
    }
    
    //MARK: - Register user, get updates and add new attributes
    
    /**
     If you want to register a user_id, you have to insert also an email.
     */
    @objc open func registerUser(email: String, user_id: String? = nil, name: String? = nil, attributes:Dictionary<String, Any>? = nil, success: SuccessResponse? = nil, failure: (() -> Void)? = nil){
        
        ping(email: email, user_id: user_id, name: name, attributes:attributes, success:{ () in
            CySocket.sharedInstance.reconfigure()
            let news = self.checkNews()
            cyPrint("Success Register User")
            success?(news.survey, news.message)
        }, failure: {
            cyPrint("Failure Register User")
            failure?()
        })
        
    }
    
    /**
     If you want to logout a user, call logoutUser() to delete all local data and de-authenticate the user
     */
    @objc open func logoutUser(){
        CyStorage.deleteCyDataModel()
        CySocket.sharedInstance.closeConnection()
        ping()
    }
    
    /**
     Get ad update from Customerly about surveys and unread messages
     */
    @objc open func update(success: SuccessResponse? = nil, failure: (() -> Void)? = nil){
        ping(success: {
            let news = self.checkNews()
            cyPrint("Success Update")
            success?(news.survey, news.message)
        }) {
            cyPrint("Failure Update")
            failure?()
        }
    }
    
    /**
     Send an update attributes to Customerly, with optionals attributes.
     Attributes need to be only on first level.
     Ex: ["Params1": 3, "Params2: "Hello"].
     */
    @objc open func setAttributes(attributes:Dictionary<String, Any>? = nil, success: SuccessResponse? = nil, failure: (() -> Void)? = nil){
        if CyStorage.getCyDataModel()?.token?.userTypeFromToken() == CyUserType.user{
            ping(attributes: attributes, success: {
                let news = self.checkNews()
                cyPrint("Success Set Attributes")
                success?(news.survey, news.message)
            }, failure: {
                cyPrint("Failure Set Attributes")
                failure?()
            })
        }
        else{
            cyPrint("Only registered users may have attributes.")
            failure?()
        }
    }
    
    //MARK: - Event
    /**
     Track an event. The event string myst be alphanumeric, eventually with _ separator.
     Valid string example: "tap_subscription_page"
     Not valid string: "tap subscription page"
     */
    @objc open func trackEvent(event: String){
        
        let trackingModel = CyTrackingRequestModel(JSON: [:])
        trackingModel?.nameTracking = event
        trackingModel?.token = CyStorage.getCyDataModel()?.token //if some data are stored, CyTrackingRequestModel contain the token
        
        CyDataFetcher.sharedInstance.trackEventAPIRequest(trackingRequest: trackingModel, completion: {
            cyPrint("Success trackEvent", event)
        }) { (error) in
            cyPrint("Failure trackEvent", error)
        }
    }
    
    //MARK: - Chat
    /**
     Open the first view controller to the user, useful to chat with your Customer Support
     */
    @objc open func openSupport(from viewController: UIViewController){
        
        let data = CyStorage.getCyDataModel()
        
        //If user exist, go to conversion list, else open a new conversation
        if data?.token?.userTypeFromToken() == CyUserType.lead || data?.token?.userTypeFromToken() == CyUserType.user{ //then, the user is lead or registered
            viewController.present(CustomerlyNavigationController(rootViewController: CustomerlyConversationListVC.instantiate()), animated: true, completion: nil)
        }
        else{
            let chatStartVC = CustomerlyChatStartVC.instantiate()
            chatStartVC.addLeftCloseButton()
            viewController.present(CustomerlyNavigationController(rootViewController: chatStartVC), animated: true, completion: nil)
        }
    }
    
    /**
     Check if there is an unread message
     */
    @objc open func isLastSupportConversationAvailable() -> Bool{
        if let data = CyStorage.getCyDataModel(){
            if (data.token?.userTypeFromToken() == CyUserType.lead || data.token?.userTypeFromToken() == CyUserType.user) && data.last_messages?.first != nil{
                return true
            }
        }
        return false
    }
    
    
    //MARK: - Survey
    /**
     Open a Survey View Controller if a survey is available
     */
    @discardableResult
    @objc open func openSurvey(from viewController: UIViewController, onShow: (() -> Void)? = nil, onDismiss: ((CySurveyDismiss) -> Void)? = nil){
        if let survey = CyStorage.getCyDataModel()?.last_surveys?.first{
            let surveyVC = CustomerlySurveyViewController.instantiate()
            surveyVC.survey = survey
            viewController.present(surveyVC, animated: true, completion: nil)
            surveyVC.onShow(on: {
                onShow!()
            })
            surveyVC.onDismiss(onDis: { (cySurveyDismiss) in
                onDismiss!(cySurveyDismiss)
            })
        }
    }
    
    /**
     Check if there is a new survey to show
     */
    @objc open func isSurveyAvailable() -> Bool{
        if let _ = CyStorage.getCyDataModel()?.last_surveys?.first{
            return true
        }
        
        return false
    }
    
    //MARK: - PRIVATE METHODS
    
    //MARK: Socket
    func emitPingActive(){
        //emit ping when user is focused on a view of customerly
        CySocket.sharedInstance.emitPingActive()
    }
    
    //MARK: Ping
    func ping(email: String? = nil, user_id: String? = nil, name: String? = nil, attributes:Dictionary<String, Any>? = nil, success: (() -> Void)? = nil, failure: (() -> Void)? = nil){
        let pingRequestModel = CyRequestPingModel(JSON: [:])
        
        //if some cookies are stored, CyRequestPingModel containes these cookies and user informations
        if let dataStored = CyStorage.getCyDataModel(){
            pingRequestModel?.token = dataStored.token
            pingRequestModel?.params?.user_id = dataStored.user?.user_id
            pingRequestModel?.params?.email = dataStored.user?.email
            pingRequestModel?.params?.name = dataStored.user?.name
            pingRequestModel?.params?.attributes = attributes
        }
        
        //if user_id != nil, email != nil, name != nil, the api call send this data, otherwise the data stored
        if email != nil{
            pingRequestModel?.params?.email = email
            pingRequestModel?.params?.user_id = user_id
        }
        if name != nil{
            pingRequestModel?.params?.name = name
        }
        
        CyDataFetcher.sharedInstance.pingAPIRequest(pingModel: pingRequestModel, completion: { (responseData) in
            CyStorage.storeCyDataModel(cyData: responseData)
            cyPrint("Success Ping")
            success?()
        }) { (error) in
            cyPrint("Failure Ping", error)
            failure?()
        }
    }
    
    func checkNews() -> (survey: Bool, message: Bool){
        var survey = false
        var message = false
        if let _ = CyStorage.getCyDataModel()?.last_surveys?.first{
            survey = true
        }
        if let _ = CyStorage.getCyDataModel()?.last_messages?.first{
            message = true
        }
        
        return (survey, message)
    }
    
    //MARK: Real time messages
    var realTimeMessagesClosure: ((CyMessageSocketModel?) -> Void)?
    
    func realTimeMessageFromSocket(socketMessage: ((CyMessageSocketModel?) -> Void)?){
        self.realTimeMessagesClosure = socketMessage
    }
    
    func requestConversationMessagesNews(timestamp: Int?, message:@escaping ((CyMessageModel?) -> Void)){
        
        let conversationRequest = CyConversationRequestModel(JSON: [:])
        conversationRequest?.token = CyStorage.getCyDataModel()?.token
        conversationRequest?.timestamp = timestamp
        
        CyDataFetcher.sharedInstance.retrieveConversationMessagesNews(conversationMessagesRequestModel: conversationRequest, completion: { (conversationMessages) in
            if conversationMessages?.messages != nil && conversationMessages?.messages?.last?.account_id != nil{
                message(conversationMessages?.messages?.last)
            }
        }, failure: { (error) in
        })
    }
    
    /**
     Closure that notify every time a new message from the support is coming.
     For render the html message you can use an attributed string.
     */
    func realTimeMessages(messageResponse:((CyMessageModel?) -> Void)?){
        realTimeMessageFromSocket { (socketMessage) in
            self.requestConversationMessagesNews(timestamp: socketMessage?.timestamp, message: { (message) in
                messageResponse?(message)
                cyPrint("New realTime message")
            })
        }
    }
    
    //MARK: Messages
    func openSupportConversationOnChat(message: CyMessageModel?){
        
        guard message != nil else {
            return
        }
        
        if let data = CyStorage.getCyDataModel(){
            if (data.token?.userTypeFromToken() == CyUserType.lead || data.token?.userTypeFromToken() == CyUserType.user){
                let chatStartVC = CustomerlyChatStartVC.instantiate()
                chatStartVC.conversationId = message?.conversation_id
                chatStartVC.addLeftCloseButton()
                UIViewController.topViewController()?.present(CustomerlyNavigationController(rootViewController: chatStartVC), animated: true, completion: nil)
            }
        }
    }
    
    /**
     If available, opens the chat on the last unread message
     */
    func openLastSupportConversation(from viewController: UIViewController){
        if let data = CyStorage.getCyDataModel(){
            if (data.token?.userTypeFromToken() == CyUserType.lead || data.token?.userTypeFromToken() == CyUserType.user) && data.last_messages?.first != nil{ //then, user is lead or register user and there is at least a message
                let chatStartVC = CustomerlyChatStartVC.instantiate()
                chatStartVC.conversationId = data.last_messages?.first?.conversation_id
                chatStartVC.addLeftCloseButton()
                viewController.present(CustomerlyNavigationController(rootViewController: chatStartVC), animated: true, completion: nil)
                
                //remove all the stored messages that contain the same conversation_id of the opened conversation
                let tempData = data
                tempData.last_messages = []
                for i in (0..<data.last_messages!.count){
                    if data.last_messages?[i].conversation_id != data.last_messages?.first?.conversation_id{
                        tempData.last_messages?.append(data.last_messages![i])
                    }
                }
                CyStorage.storeCyDataModel(cyData: tempData)
            }
        }
    }
    
    
}
