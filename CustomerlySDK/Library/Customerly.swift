//
//  Customerly.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/10/16.
//
//

import Kingfisher

open class Customerly: NSObject {
    
    open static let sharedInstance = Customerly()
    var customerlyAppId: String = ""
    var customerlyIsOpen = false
    var bannerMessages: [CyMessageModel] = []
    
    /**
     Enable verbose logging, that is useful for debugging. By default is disabled.
     */
    open var verboseLogging: Bool = false
    
    /**
     Enable or disable the message receiving. It is ENABLED by default.
     */
    open var supportEnabled: Bool = true
    
    /**
     Enable or disable the survey receiving. It is ENABLED by default.
     */
    open var surveyEnabled: Bool = true
    
    //MARK: - Init
    override init() {
        super.init()
    }
    
    //MARK: - Configuration
    @objc open func configure(appId: String, widgetColor: UIColor? = nil){
        customerlyAppId = appId
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
            self.showCustomizedBanner(with: message)
        }
    }
    
    /**
     Update Customerly SDK data every time app is opened by adding the following code to your AppDelegate:
     ```
     func applicationDidBecomeActive(_ application: UIApplication) {
     Customerly.sharedInstance.activateApp()
     }
     ```
     */
    @objc open func activateApp(){
        ping(success: {
            //Success
            let message = self.getLastUnreadMessage()
            self.showCustomizedBanner(with: message)
            self.openSurveyIfAvailable()
        }) {
            //Failure
        }
    }
    
    //MARK: - Register user, get updates and add new attributes or company
    
    /**
     If you want to register a user_id, you have to insert at least an email.
     */
    @objc open func registerUser(email: String, user_id: String? = nil, name: String? = nil, attributes:Dictionary<String, Any>? = nil, company:Dictionary<String, Any>? = nil, success: (() -> Void)? = nil, failure: (() -> Void)? = nil){
        
        ping(email: email, user_id: user_id, name: name, attributes: attributes, company: company, success:{ () in
            CySocket.sharedInstance.reconfigure()
            cyPrint("Success Register User")
            let message = self.getLastUnreadMessage()
            self.showCustomizedBanner(with: message)
            success?()
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
    @objc open func update(success: (() -> Void)? = nil, failure: (() -> Void)? = nil){
        ping(success: {
            self.openSurveyIfAvailable()
            cyPrint("Success Update")
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
    @objc open func setAttributes(attributes:Dictionary<String, Any>? = nil, success: (() -> Void)? = nil, failure: (() -> Void)? = nil){
        if CyStorage.getCyDataModel()?.token?.userTypeFromToken() == CyUserType.user{
            ping(attributes: attributes, success: {
                cyPrint("Success Set Attributes")
                success?()
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
    
    /**
     Send an update company to Customerly.
     Attributes need to be only on first level.
     When you set a company, "company_id" and "name" are required fields for adding or modifying a company.
     Ex: ["company_id": "123", "name: "My Company", "plan": 3].
     */
    @objc open func setCompany(company:Dictionary<String, Any>? = nil, success: (() -> Void)? = nil, failure: (() -> Void)? = nil){
        if CyStorage.getCyDataModel()?.token?.userTypeFromToken() == CyUserType.user{
            ping(company: company, success: {
                cyPrint("Success Set Company")
                success?()
            }, failure: {
                cyPrint("Failure Set Company")
                failure?()
            })
        }
        else{
            cyPrint("Only registered users may have companies attributes.")
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
        
        let data = CyStorage.getCyDataModel()
        
        if sdkNeedUpdate(min_version_required: data?.min_version_ios){
            return
        }
        
        let trackingModel = CyTrackingRequestModel(JSON: [:])
        trackingModel?.nameTracking = event
        trackingModel?.token = data?.token //if some data are stored, CyTrackingRequestModel contain the token
        
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
        if sdkNeedUpdate(min_version_required: data?.min_version_ios){
            return
        }
        
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
    
    
    //MARK: - PRIVATE METHODS
    
    //MARK: Ping
    func ping(email: String? = nil, user_id: String? = nil, name: String? = nil, attributes:Dictionary<String, Any>? = nil, company:Dictionary<String, Any>? = nil, success: (() -> Void)? = nil, failure: (() -> Void)? = nil){
        let pingRequestModel = CyRequestPingModel(JSON: [:])
        
        //if some cookies are stored, CyRequestPingModel containes these cookies and user informations
        if let dataStored = CyStorage.getCyDataModel(){
            pingRequestModel?.token = dataStored.token
            pingRequestModel?.params?.user_id = dataStored.user?.user_id
            pingRequestModel?.params?.email = dataStored.user?.email
            pingRequestModel?.params?.name = dataStored.user?.name
            pingRequestModel?.params?.attributes = attributes
            pingRequestModel?.params?.company = company
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
            
            if sdkNeedUpdate(min_version_required: responseData?.min_version_ios){
                failure?()
                return
            }
            
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
    
    /*
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
    
    //MARK: Chat
    func openSupportConversationOnMessage(message: CyMessageModel?){
        
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
    
    // If available, opens the chat on the last unread message
    func openLastSupportConversation(from viewController: UIViewController){
        
        if let lastMessage = getLastUnreadMessage(){
            let chatStartVC = CustomerlyChatStartVC.instantiate()
            chatStartVC.conversationId = lastMessage.conversation_id
            chatStartVC.addLeftCloseButton()
            viewController.present(CustomerlyNavigationController(rootViewController: chatStartVC), animated: true, completion: nil)
        }
    }
    
    //Get the last unread message, and remove all the stored messages that contain the same conversation_id
    func getLastUnreadMessage() -> CyMessageModel?{
        if let data = CyStorage.getCyDataModel(){
            //user is lead or register user and there is at least a message
            if (data.token?.userTypeFromToken() == CyUserType.lead || data.token?.userTypeFromToken() == CyUserType.user) && data.last_messages?.first != nil{
                
                
                let message = data.last_messages?.first
                
                //remove all the stored messages that contain the same conversation_id of the opened conversation
                let tempData = data
                tempData.last_messages = []
                for i in (0..<data.last_messages!.count){
                    if data.last_messages?[i].conversation_id != data.last_messages?.first?.conversation_id{
                        tempData.last_messages?.append(data.last_messages![i])
                    }
                }
                CyStorage.storeCyDataModel(cyData: tempData)
                
                return message
            }
        }
        
        return nil
    }
    
    //Check if there is an unread message
    func isLastSupportConversationAvailable() -> Bool{
        if let data = CyStorage.getCyDataModel(){
            if (data.token?.userTypeFromToken() == CyUserType.lead || data.token?.userTypeFromToken() == CyUserType.user) && data.last_messages?.first != nil{
                return true
            }
        }
        return false
    }
    
    //MARK: Banner
    func showCustomizedBanner(with message: CyMessageModel?){
        guard Customerly.sharedInstance.customerlyIsOpen != true && Customerly.sharedInstance.supportEnabled == true else {
            return
        }
        
        guard message != nil else {
            return
        }
        
        //if a message is a clone of a message actually showed in a banner, not show
        for aMessage in bannerMessages{
            if aMessage.conversation_message_id == message?.conversation_message_id{
                return
            }
        }
        
        var messageContent = message?.content
        if message?.rich_mail == true{
            messageContent = "chatViewRichMessageText".localized(comment: "Chat View")
        }
        
        let banner = CyBanner(name: message?.account?.name ?? "supportTitle".localized(comment: "Banner Title"), attributedSubtitle: messageContent?.attributedStringFromHTML(font: UIFont(name: "Helvetica", size: 14.0)!, color:  UIColor(hexString: "#666666")), image: nil)
        banner.viewBanner?.avatarImageView?.kf.setImage(with: adminImageURL(id: message?.account_id, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        self.bannerMessages.append(message!)
        banner.show(didTapBlock: {
            self.openSupportConversationOnMessage(message: message)
            if message?.rich_mail == true{
                if message?.rich_mail_url != nil && URL(string: message!.rich_mail_url!) != nil{
                    UIApplication.shared.openURL(URL(string: message!.rich_mail_url!)!)
                }
            }
        })
        
        banner.dismissed {
            for i in 0..<self.bannerMessages.count{
                if self.bannerMessages[i].conversation_message_id == message?.conversation_message_id{
                    self.bannerMessages.remove(at: i)
                    break
                }
            }
        }
        
        CySound.playNotification()
    }
    
    //MARK: Surveys
    
    // Open a Survey View Controller if a survey is available
    func openSurveyIfAvailable(){
        
        guard Customerly.sharedInstance.customerlyIsOpen != true && Customerly.sharedInstance.surveyEnabled == true else {
            return
        }
        
        guard UIViewController.topViewController() != nil else {
            return
        }
        
        openSurvey(from: UIViewController.topViewController()!, onShow: {
            Customerly.sharedInstance.customerlyIsOpen = true
        }) { (surveyDismiss) in
            Customerly.sharedInstance.customerlyIsOpen = false
        }
    }
    
    func openSurvey(from viewController: UIViewController, onShow: (() -> Void)? = nil, onDismiss: ((CySurveyDismiss) -> Void)? = nil){
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
    
    // Check if there is a new survey to show
    func isSurveyAvailable() -> Bool{
        if let _ = CyStorage.getCyDataModel()?.last_surveys?.first{
            return true
        }
        
        return false
    }
}
