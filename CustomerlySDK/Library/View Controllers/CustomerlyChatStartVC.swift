//
//  CyChatStartVC.swift
//  Customerly
//
//  Created by Paolo Musolino on 11/11/16.
//
//

import UIKit

class CustomerlyChatStartVC: CyViewController{
    
    @IBOutlet weak var chatTableView: CyTableView!
    @IBOutlet weak var chatTextField: CyTextField!
    @IBOutlet weak var attachmentsButton: CyButton!
    @IBOutlet weak var sendMessageButton: CyButton!
    @IBOutlet weak var poweredByButton: CyButton!
    @IBOutlet weak var composeMessageViewBottomConstraint: NSLayoutConstraint!
    
    var data: CyDataModel?
    
    var conversationId: Int?
    var messages : [CyMessageModel] = []
    var onMessageSocketUUID: UUID? //useful to remove handler "on message" when view controller is dismissed
    
    //MARK: - Initialiser
    static func instantiate() -> CustomerlyChatStartVC
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyChatStartVC") as! CustomerlyChatStartVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView configuration
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 124
        chatTableView.register(UINib(nibName: "MessageCell", bundle:Bundle(for: self.classForCoder)), forCellReuseIdentifier: "messageCell")
        chatTableView.register(UINib(nibName: "MessageWithImageCell", bundle:Bundle(for: self.classForCoder)), forCellReuseIdentifier: "messageWithImagesCell")
        data = CyStorage.getCyDataModel()
        poweredByButton.setTitle("chatViewPoweredBy".localized(comment: "Chat View"), for: .normal)
        poweredByButton.isHidden = !(data?.app_config?.powered_by ?? true) //show or hide powered by button
        
        chatTextField.placeholder = "chatViewTextFieldPlaceholder".localized(comment: "Chat View")
        chatTextField.cyDelegate = self
        imagePickerDelegate = self
        
        title = "chatTitleView".localized(comment: "Chat View")
        
        requestConversationMessages(conversation_id: conversationId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onMessageArrived()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //On vc dismiss remove (off) "on message" socket handler
        CySocket.sharedInstance.removeHandlerWithUUID(uuid: onMessageSocketUUID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: APIs
    func requestConversationMessages(conversation_id: Int?){
        guard conversation_id != nil else {
            return
        }
        
        let conversationRequest = CyConversationRequestModel(JSON: [:])
        conversationRequest?.token = CyStorage.getCyDataModel()?.token
        conversationRequest?.params?.conversation_id = conversation_id
        
        var hud : CyView?
        hud = showLoader(view: self.view)
        
        CyDataFetcher.sharedInstance.retrieveConversationMessages(conversationMessagesRequestModel: conversationRequest, completion: { (conversationMessages) in
            self.messages = conversationMessages?.messages ?? []
            self.messageSeen(message: self.getTheLastMessageFromAdmin(messagesArray: conversationMessages?.messages, conversation_id: self.conversationId))
            self.chatTableView.reloadData()
            if self.messages.count > 0{
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: true)
            }
            self.hideLoader(loaderView: hud)
        }, failure: { (error) in
            self.hideLoader(loaderView: hud)
        })
    }
    
    func requestConversationMessagesNews(conversation_id: Int?, timestamp: Int?){
        guard conversation_id != nil else {
            return
        }
        
        let conversationRequest = CyConversationRequestModel(JSON: [:])
        conversationRequest?.token = CyStorage.getCyDataModel()?.token
        conversationRequest?.timestamp = timestamp
        
        CyDataFetcher.sharedInstance.retrieveConversationMessagesNews(conversationMessagesRequestModel: conversationRequest, completion: { (conversationMessages) in
            if conversationMessages?.messages != nil{
                self.messages.append(contentsOf: self.getOnlyMessagesForThisConversation(messagesArray: conversationMessages?.messages, conversation_id: self.conversationId))
                self.messageSeen(message: self.getTheLastMessageFromAdmin(messagesArray: conversationMessages?.messages, conversation_id: self.conversationId))
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .top, animated: true)
            }
        }, failure: { (error) in
        })
    }
    
    func sendMessage(message: String?, email: String? = nil, conversation_id: Int? = nil, attachment: CyMessageAttachmentRequestModel? = nil){
        
        let hud = showLoader(view: self.view)
        
        if email != nil{
            let pingRequestModel = CyRequestPingModel(JSON: [:])
            pingRequestModel?.token = CyStorage.getCyDataModel()?.token
            pingRequestModel?.params?.lead_email = email
            
            CyDataFetcher.sharedInstance.pingAPIRequest(pingModel: pingRequestModel, completion: { (responseData) in
                CyStorage.storeCyDataModel(cyData: responseData)
                self.sendMessageRequest(message: message, email: email, conversation_id: conversation_id, attachment: attachment, hud: hud)
            }, failure: { (error) in
                self.hideLoader(loaderView: hud)
            })
            
            return
        }
        
        sendMessageRequest(message: message, email: email, conversation_id: conversation_id, attachment: attachment, hud: hud)
    }
    
    func sendMessageRequest(message: String?, email: String? = nil, conversation_id: Int? = nil, attachment: CyMessageAttachmentRequestModel? = nil, hud: CyView){
        
        let messageRequest = CySendMessageRequestModel(JSON: [:])
        if let dataStored = CyStorage.getCyDataModel(){
            messageRequest?.token = dataStored.token
            messageRequest?.params?.message = message
            messageRequest?.params?.conversation_id = conversation_id
            if attachment != nil{
                messageRequest?.params?.attachments?.append(attachment!)
            }
        }
        
        CyDataFetcher.sharedInstance.sendMessage(messageModel: messageRequest, completion: { (responseSendMessage) in
            self.chatTextField.text = ""
            
            //if user lead, reconfigure socket, and emit only when reconnected
            if email != nil{
                CySocket.sharedInstance.reconfigure(connected: { (connected) in
                    if connected == true{
                        CySocket.sharedInstance.emitMessage(message: message ?? "", timestamp: responseSendMessage?.timestamp ?? Int(Date().timeIntervalSince1970))
                        self.onMessageArrived()
                    }
                })
            }
            else{
                CySocket.sharedInstance.emitMessage(message: message ?? "", timestamp: responseSendMessage?.timestamp ?? Int(Date().timeIntervalSince1970))
            }
            
            self.conversationId = responseSendMessage?.conversation?.conversation_id
            self.hideLoader(loaderView: hud)
        }, failure: { (error) in
            self.hideLoader(loaderView: hud)
        })
    }
    
    func messageSeen(message: CyMessageModel?){
        guard message?.account != nil else {
            return
        }
        
        CySocket.sharedInstance.emitSeen(messageId: message?.conversation_message_id, timestamp: Int(Date().timeIntervalSince1970))
        
        let messageSeenRequest = CyMessageSeenRequestModel(JSON: [:])
        messageSeenRequest?.conversation_message_id = message?.conversation_message_id
        messageSeenRequest?.seen_date = Int(Date().timeIntervalSince1970)
        messageSeenRequest?.token = CyStorage.getCyDataModel()?.token
        CyDataFetcher.sharedInstance.messageSeen(messageSeenRequestModel: messageSeenRequest, completion: {
            
        }) { (error) in
            
        }
    }
    
    func onMessageArrived(){
        if CySocket.sharedInstance.isConnected(){
            //New message is arrived
            onMessageSocketUUID = CySocket.sharedInstance.onMessage { (message) in
                self.requestConversationMessagesNews(conversation_id: self.conversationId, timestamp: message?.timestamp)
            }
        }
    }
    
    //MARK: Utils
    func lastAdminActivity() -> String{
        guard data?.active_admins?.count != nil, (data?.active_admins?.count)! >= 1 else {
            return ""
        }
        
        if let last_activity = data?.active_admins?[0].last_active{
            return Date.timeAgoSinceUnixTime(unix_time: last_activity, currentDate: Date())
        }
        
        return ""
    }
    
    func getAttachmentsImages(message: CyMessageModel) -> [String]?{
        var images : [String] = []
        if message.attachments != nil{
            for attachment in message.attachments!{
                if attachment.path?.containOneSuffix(suffixes: [".jpg", ".JPEG", ".jpeg", ".png", ".PNG", ".tif", ".TIFF"]) == true{
                    images.append(attachment.path!)
                }
            }
        }
        if let imagesFromHTML = message.content?.arrayOfImagesFromHTML(){
            images = images + imagesFromHTML
        }
        
        return images.count > 0 ? images : nil
    }
    
    func getOnlyMessagesForThisConversation(messagesArray : [CyMessageModel]?, conversation_id: Int?) -> [CyMessageModel]{
        guard messagesArray != nil && conversation_id != nil else {
            return []
        }
        
        var result : [CyMessageModel] = []
        for message in messagesArray!{
            if message.conversation_id == conversation_id{
                result.append(message)
            }
        }
        
        return result
    }
    
    func getTheLastMessageFromAdmin(messagesArray: [CyMessageModel]?, conversation_id: Int?) -> CyMessageModel?{
        let messagesArray = getOnlyMessagesForThisConversation(messagesArray: messagesArray, conversation_id: conversation_id)
        for message in messagesArray.reversed(){
            if message.account != nil{
                return message
            }
        }
        
        return nil
    }
    
    //MARK: Message Array Manipulation
    func addMessages(messagesArray: [CyMessageModel]? = nil){
        if messagesArray != nil{
            for message in messagesArray!{
                if message.conversation_id == conversationId{
                    messages.append(message)
                }
            }
            chatTableView.reloadData()
        }
    }
    
    //MARK: Actions
    @IBAction func newAttachments(_ sender: Any) {
        self.openImagePickerActionSheet()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        guard chatTextField.text != "" else{
            return
        }
        
        if CyStorage.getCyDataModel()?.user != nil{
            self.sendMessage(message: self.chatTextField.text, conversation_id: self.conversationId)
        }
        else{
            self.chatTextField.resignFirstResponder()
            
            showAlertWithTextField(title: data?.app?.name ?? "", message: "chatInsertEmail".localized(comment: "Chat View"), buttonTitle: "chatOK".localized(comment: "Chat View"), buttonCancel: "chatCancel".localized(comment: "Chat View"), textFieldPlaceholder: "chatEmail".localized(comment: "Chat View"), completion: { (email) in
                
                self.sendMessage(message: self.chatTextField.text, email: email)
            }) { (cancel) in
                
            }
        }
    }
    
    @IBAction func openPoweredBy(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: CUSTOMERLY_URL)!)
    }
}

extension CustomerlyChatStartVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if conversationId != nil && messages.count >= 0 {
            return messages.count
        }
        
        //if no admins, the related admin cell and info cell is not showed
        guard (data?.active_admins?.count) != nil else {
            return 0
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if conversationId != nil && messages.count >= 0{
            
            var cell : CyMessageTableViewCell?
            
            let message = messages[indexPath.item]
            
            if let images = getAttachmentsImages(message: message){
                cell = tableView.dequeueReusableCell(withIdentifier: "messageWithImagesCell", for: indexPath) as? CyMessageTableViewCell
                cell?.imagesAttachments = images
                cell?.cellContainsImages(configForImages: true)
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? CyMessageTableViewCell
                cell?.cellContainsImages(configForImages: false)
            }
            cell?.vcThatShowThisCell = self
            
            if message.account_id != nil{
                cell?.adminAvatar.kf.setImage(with: adminImageURL(id: message.account_id, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                cell?.setAdminVisual()
            }else{
                cell?.userAvatar.kf.setImage(with: userImageURL(id: message.user_id, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                cell?.setUserVisual()
            }
            
            cell?.messageTextView.attributedText = message.content!.removeImageTagsFromHTML().attributedStringFromHTMLWithImages(font: UIFont.systemFont(ofSize: 14.0), color: message.account_id != nil ? UIColor(hexString:"#999999") : UIColor.white, imageMaxWidth: abs(self.view.bounds.size.width/2))
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraintsIfNeeded()
            cell?.setNeedsLayout()
            cell?.layoutIfNeeded()
            return cell!
        }
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "activeAdminsCell", for: indexPath) as! CyActiveAdminsTableViewCell
            
            cell.active_admins = data?.active_admins
            cell.lastActivityLabel.text = "chatAdminLastActivity".localized(comment: "Chat View") + " " + lastAdminActivity()
            cell.welcomeMessageLabel.text = data?.token?.userTypeFromToken() == CyUserType.user ? data?.app_config?.welcome_message_users : data?.app_config?.welcome_message_visitors
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCustomerlyCell", for: indexPath) as! CyInfoTableViewCell
            cell.contactSupportLabel.text = "chatViewContactSupportLabel".localized(comment: "Chat View")
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        }
    }
}

extension CustomerlyChatStartVC: CyTextFieldDelegate{
    func keyboardShowed(height: CGFloat) {
        composeMessageViewBottomConstraint.constant = height
    }
    
    func keyboardHided(height: CGFloat) {
        composeMessageViewBottomConstraint.constant = 0
    }
    
    func isTyping(typing: Bool) {
        CySocket.sharedInstance.emitTyping(typing: typing, conversationId: conversationId)
    }
}

extension CustomerlyChatStartVC: CyImagePickerDelegate{
    func imageFromPicker(image: UIImage?) {
        if image != nil && CyStorage.getCyDataModel()?.user != nil{
            let messageAttachment = CyMessageAttachmentRequestModel(JSON: [:])
            messageAttachment?.filename = "image.jpg"
            messageAttachment?.base64 = UIImageJPEGRepresentation(image!, 0.7)?.base64EncodedString()
            sendMessage(message: "", conversation_id: self.conversationId, attachment: messageAttachment)
        }
    }
}

