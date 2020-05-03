//
//  CustomerlyConversationListVC.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CustomerlyConversationListVC: CyViewController {
    
    @IBOutlet weak var backgroundImageView: CyImageView!
    @IBOutlet weak var tableView: CyTableView!
    @IBOutlet weak var newConversationButton: CyButton!
    @IBOutlet weak var poweredByButton: CyButton!
    var conversations : [CyConversationModel]?
    var data: CyDataModel?
    var onMessageSocketUUID: UUID? //useful to remove handler "on message" when view controller is dismissed
    
    
    //MARK: - Initialiser
    static func instantiate() -> CustomerlyConversationListVC
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyConversationListVC") as! CustomerlyConversationListVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView configuration
        tableView.delegate = self
        tableView.dataSource = self
        data = CyStorage.getCyDataModel()
        newConversationButton.setTitle("newConversationButton".localized(comment: "Conversation List"), for: .normal)
        poweredByButton.setTitle("conversationListPoweredBy".localized(comment: "Conversation List"), for: .normal)
        poweredByButton.isHidden = !(data?.app_config?.powered_by ?? true) //show or hide powered by button
        backgroundImageView.kf.setImage(with: URL(string: data?.app_config?.widget_background_url ?? ""))
        
        title = "supportTitle".localized(comment: "Conversation List")
        addLeftCloseButton()
        
        tableView.addPullToRefresh {
            self.requestConversations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onMessageArrived()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestConversations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //On vc dismiss remove (off) "on message" socket handler
        CySocket.sharedInstance.removeHandlerWithUUID(uuid: onMessageSocketUUID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: APIs & Socket
    func requestConversations(loader: Bool = true){
        let conversationRequest = CyConversationRequestModel(JSON: [:])
        conversationRequest?.token = CyStorage.getCyDataModel()?.token
        conversationRequest?.params?.lead_hash = CyStorage.getCyDataModel()?.lead_hash
        
        var hud : CyView?
        if tableView.pullToRefreshIsRefreshing() == false && loader == true {
            hud = showLoader(view: self.view)
        }
        
        CyDataFetcher.sharedInstance.retriveConversations(conversationRequestModel: conversationRequest, completion: { (conversationResponse) in
            self.conversations = conversationResponse?.conversations
            self.tableView.reloadData()
            self.hideLoader(loaderView: hud)
            self.tableView.endPulltoRefresh()
        }, failure: { (error) in
            self.hideLoader(loaderView: hud)
            self.tableView.endPulltoRefresh()
        })
        
    }
    
    func onMessageArrived(){
        if CySocket.sharedInstance.isConnected(){
            //New message is arrived
            onMessageSocketUUID = CySocket.sharedInstance.onMessage { (message) in
                self.requestConversations(loader: false)
            }
        }
    }
    
    //MARK: Actions
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newConversation(_ sender: Any) {
        //Open chat VC with a new conversation
        let chatVC = CyViewController.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyChatStartVC") as! CustomerlyChatStartVC
        show(chatVC, sender: self)
    }
    
    @IBAction func openPoweredBy(_ sender: Any) {
        UIApplication.shared.open(URL(string: CUSTOMERLY_URL)!, options: [:]) { (opened) in
        }
    }
}

extension CustomerlyConversationListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! CyConversationTableViewCell
        
        if let conversation = conversations?[indexPath.row]{
            if conversation.last_account != nil{
                cell.userAvatarImageView.kf.setImage(with: adminImageURL(id: conversation.last_account!.account_id, pxSize: 100), placeholder: nil)
                cell.userNameLabel.text = conversation.last_account?.name
            }else{
                cell.userAvatarImageView.kf.setImage(with: userImageURL(id: conversation.user_id, pxSize: 100), placeholder: nil)
                cell.userNameLabel.text = "youUser".localized(comment: "Conversation list")
            }
            
            cell.unreadConversation(unread: conversation.unread)
            
            cell.lastChatConversationLabel.attributedText = conversation.last_message_abstract?.attributedStringFromHTML(font: UIFont(name: "Helvetica", size: 14.0)!, color:  (conversation.unread == true ? UIColor.black : UIColor(hexString: "#999999")))
            cell.dateLabel.text = Date.timeAgoSinceUnixTime(unix_time: conversation.last_message_date!, currentDate: Date())
        }
        
        return cell
    }
}

extension CustomerlyConversationListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Open chat VC with on specific conversation
        let chatVC = CyViewController.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyChatStartVC") as! CustomerlyChatStartVC
        chatVC.conversationId = conversations?[indexPath.row].conversation_id
        show(chatVC, sender: self)
    }
}
