//
//  CyChatStartVC.swift
//  Customerly

import UIKit

class CustomerlyChatStartVC: CyViewController{
    
    @IBOutlet weak var backgroundImageView: CyImageView!
    @IBOutlet weak var chatTableView: CyTableView!
    @IBOutlet weak var chatTextField: CyTextField!
    @IBOutlet weak var attachmentsButton: CyButton!
    @IBOutlet weak var sendMessageButton: CyButton!
    @IBOutlet weak var poweredByButton: CyButton!
    @IBOutlet weak var composeMessageViewBottomConstraint: NSLayoutConstraint!
    
    var data: CyDataModel? = CyStorage.getCyDataModel()
    
    var conversationId: Int?
    var messages: [CyMessageModel] = []
    var dateSections : [Date] = [] //dates section (every date is a day with a list of messages inside)
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
        chatTableView.delegate = self
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 124
        chatTableView.register(UINib(nibName: "MessageCell", bundle:CyBundle.getBundle()), forCellReuseIdentifier: "messageCell")
        chatTableView.register(UINib(nibName: "MessageWithImageCell", bundle:CyBundle.getBundle()), forCellReuseIdentifier: "messageWithImagesCell")
        poweredByButton.setTitle("chatViewPoweredBy".localized(comment: "Chat View"), for: .normal)
        poweredByButton.isHidden = !(data?.app_config?.branded_widget ?? true) //show or hide powered by button
        backgroundImageView.kf.setImage(with: URL(string: data?.app_config?.widget_background_url ?? ""))
        
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
        conversationRequest?.params?.lead_hash = CyStorage.getCyDataModel()?.lead_hash
        
        var hud : CyView?
        hud = showLoader(view: self.view)
        
        CyDataFetcher.sharedInstance.retrieveConversationMessages(conversationMessagesRequestModel: conversationRequest, completion: { (conversationMessages) in
            self.messages = conversationMessages?.messages ?? []
            self.messageSeen(message: self.getTheLastMessageFromAdmin(messagesArray: conversationMessages?.messages, conversation_id: self.conversationId))
            self.chatTableView.reloadData()
            self.scrollToLastMessage()
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
        conversationRequest?.params?.lead_hash = CyStorage.getCyDataModel()?.lead_hash
        
        CyDataFetcher.sharedInstance.retrieveConversationMessagesNews(conversationMessagesRequestModel: conversationRequest, completion: { (conversationMessages) in
            if conversationMessages?.messages != nil{
                self.messages.append(contentsOf: self.getOnlyMessagesForThisConversation(messagesArray: conversationMessages?.messages, conversation_id: self.conversationId))
                self.messageSeen(message: self.getTheLastMessageFromAdmin(messagesArray: conversationMessages?.messages, conversation_id: self.conversationId))
                self.chatTableView.reloadData()
                self.scrollToLastMessage()
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
            messageRequest?.params?.lead_hash = dataStored.lead_hash
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
            CyStorage.storeCySingleParameters(lead_hash: responseSendMessage?.lead_hash)
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
    func conversationExist() -> Bool{
        if conversationId != nil && messages.count >= 0 {
            return true
        }
        
        return false
    }
    
    func lastAdminActivity() -> String{
        guard data?.active_admins?.count != nil, (data?.active_admins?.count)! >= 1 else {
            return ""
        }
        
        if let last_activity = data?.active_admins?[0].last_active{
            return Date.timeAgoSinceUnixTime(unix_time: last_activity, currentDate: Date())
        }
        
        return ""
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
    
    func scrollToLastMessage(){
        if dateSections.count > 0{
            let messagesInSection = getMessagesInSection(messagesArray: messages, sectionDate: dateSections.last!)
            if messagesInSection.count > 0{
                self.chatTableView.scrollToRow(at: IndexPath(row: messagesInSection.count-1, section: dateSections.count-1), at: .top, animated: true)
            }
        }
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
    
    func generateDateSections(messagesArray: [CyMessageModel]) -> [Date]{
        
        var tempArray: [Date] = []
        for message in messagesArray{
            if let sent_date = message.sent_date{
                let messageDate = Date(timeIntervalSince1970:TimeInterval(Double(sent_date)))
                
                if tempArray.count == 0{
                    tempArray.append(messageDate)
                }
                
                var add = false
                for date in tempArray{
                    if messageDate.isTheSameDay(of: date){
                        add = false
                    }
                    else{
                        add = true
                    }
                }
                
                if add == true{
                    tempArray.append(messageDate)
                }
            }
        }
        
        return tempArray
    }
    
    func getMessagesInSection(messagesArray: [CyMessageModel], sectionDate: Date) -> [CyMessageModel]{
        
        var messageArray: [CyMessageModel] = []
        
        var i = 0
        for message in messagesArray{
            if let sent_date = message.sent_date{
                let messageDate = Date(timeIntervalSince1970:TimeInterval(Double(sent_date)))
                
                if messageDate.isTheSameDay(of: sectionDate){
                    
                    //Avatar configuration
                    if i == 0 {
                        message.showAvatar = true
                    }
                    else{
                        if messagesArray[i-1].user_id != nil && messagesArray[i-1].user_id == message.user_id {
                            message.showAvatar = false
                        }
                        else if messagesArray[i-1].account_id != nil && messagesArray[i-1].account_id == message.account_id {
                            message.showAvatar = false
                        }
                        else{
                            message.showAvatar = true
                        }
                    }
                    messageArray.append(message)
                }
            }
            i += 1
        }
        
        return messageArray
    }
    
    //MARK: Actions
    @IBAction func newAttachments(_ sender: Any) {
        self.openImagePickerActionSheet(from: attachmentsButton)
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
            showAlertWithTextField(title: data?.app?.name ?? "", message: "chatInsertEmail".localized(comment: "Chat View"), buttonTitle: "chatOK".localized(comment: "Chat View"), buttonCancel: "chatCancel".localized(comment: "Chat View"), textFieldPlaceholder: "chatEmail".localized(comment: "Chat View"), completion: { [weak self] (email) in
                self?.sendMessage(message: self?.chatTextField.text, email: email)
            }, cancel: {
                
            })
        }
    }
    
    @IBAction func openPoweredBy(_ sender: Any) {
        UIApplication.shared.open(URL(string: CUSTOMERLY_URL)!, options: [:], completionHandler: nil)
    }
}

extension CustomerlyChatStartVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if conversationExist(){
            dateSections = generateDateSections(messagesArray: messages)
            return dateSections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if conversationExist(){
            return 35
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if conversationExist(){
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerDateCell") as! CyHeaderDateTableViewCell
            headerCell.dateLabel.text = dateSections[section].monthDayYear()
            return headerCell
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if conversationExist(){
            return getMessagesInSection(messagesArray: messages, sectionDate:dateSections[section]).count
        }
        
        //if no admins, the related admin cell and info cell is not showed
        guard (data?.active_admins?.count) != nil else {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if conversationExist(){
            
            var cell : CyMessageTableViewCell?
            
            let message = getMessagesInSection(messagesArray: messages, sectionDate: dateSections[indexPath.section])[indexPath.row]
            
            if let images = message.attachmentsImages{
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
                cell?.adminAvatar.kf.setImage(with: adminImageURL(id: message.account_id, pxSize: 100), placeholder: nil)
                cell?.setAdminVisual()
                cell?.adminAvatar.isHidden = !message.showAvatar
            }else{
                cell?.userAvatar.kf.setImage(with: userImageURL(id: message.user_id, pxSize: 100), placeholder: nil)
                cell?.setUserVisual(bubbleColor: self.navigationController?.navigationBar.barTintColor)
                cell?.userAvatar.isHidden = !message.showAvatar
            }
            
            cell?.messageTextView.attributedText = message.attributedMessage
            
            if message.rich_mail == true{
                cell?.messageTextView.isUserInteractionEnabled = false
            }
            else{
                cell?.messageTextView.attributedText = message.attributedMessage
                cell?.messageTextView.isUserInteractionEnabled = true
            }
            
            cell?.dateLabel.textColor = message.account_id != nil ? UIColor(hexString:"#999999") : UIColor.white
            cell?.dateLabel.alpha = 0.6
            if let sent_date = message.sent_date {
                cell?.dateLabel.text = Date(timeIntervalSince1970:TimeInterval(sent_date)).hoursAndMinutes()
            }
            
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraintsIfNeeded()
            cell?.setNeedsLayout()
            cell?.layoutIfNeeded()
            return cell!
        }
        
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
}

extension CustomerlyChatStartVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if conversationExist(){
            let message = getMessagesInSection(messagesArray: messages, sectionDate: dateSections[indexPath.section])[indexPath.row]
            if message.rich_mail == true{
                if message.rich_mail_url != nil, let url = URL(string: message.rich_mail_url!){
                    openSafariVC(url: url)
                }
            }
        }
    }
}

extension CustomerlyChatStartVC: CyTextFieldDelegate{
    func keyboardShowed(height: CGFloat) {
        composeMessageViewBottomConstraint.constant = -height
    }
    
    func keyboardHided(height: CGFloat) {
        composeMessageViewBottomConstraint.constant = 0
    }
    
    func isTyping(typing: Bool) {
        CySocket.sharedInstance.emitTyping(typing: typing, text_preview: chatTextField.text, conversationId: conversationId)
    }
}

extension CustomerlyChatStartVC: CyImagePickerDelegate{
    func imageFromPicker(image: UIImage?) {
        if image != nil && CyStorage.getCyDataModel()?.user != nil{
            let messageAttachment = CyMessageAttachmentRequestModel(JSON: [:])
            messageAttachment?.filename = "cyimage.jpg"
            messageAttachment?.base64 = image!.jpegData(compressionQuality: 0.7)?.base64EncodedString()
            sendMessage(message: "", conversation_id: self.conversationId, attachment: messageAttachment)
        }
    }
}

