//
//  CustomerlyConversationListVC.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CustomerlyConversationListVC: CyViewController {
    
    @IBOutlet weak var tableView: CyTableView!
    var conversations : [CyConversationModel]?
    var data: CyDataModel?
    
    //MARK: - Initialiser
    static func instantiate() -> CustomerlyConversationListVC
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlyChat", vcIdentifier: "CustomerlyConversationListVC") as! CustomerlyConversationListVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView configuration
        tableView.dataSource = self
        data = CyStorage.getCyDataModel()
        
        title = data?.app?.name
        
        tableView.addPullToRefresh {
            self.requestConversations()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestConversations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestConversations(){
        let conversationRequest = CyConversationRequestModel(JSON: [:])
        if let dataStored = CyStorage.getCyDataModel(){
            conversationRequest?.settings?.user_id = dataStored.user?.user_id
            conversationRequest?.settings?.email = dataStored.user?.email
            conversationRequest?.settings?.name = dataStored.user?.name
            conversationRequest?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            conversationRequest?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            conversationRequest?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
        }
        
        
        var hud : CyView?
        if tableView.pullToRefreshIsRefreshing() == false{
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
    
}

extension CustomerlyConversationListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! CyConversationTableViewCell
        
        if let conversation = conversations?[indexPath.row]{
            if conversation.last_account != nil{
                cell.userAvatarImageView.kf.setImage(with: adminImageURL(id: conversation.last_account!.account_id!, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                cell.userNameLabel.text = conversation.last_account?.name
                cell.lastChatConversationLabel.text = conversation.last_message_abstract
                cell.dateLabel.text = Date.timeAgoSinceUnixTime(unix_time: conversation.last_message_date!, currentDate: Date())
            }else{
                cell.userAvatarImageView.kf.setImage(with: userImageURL(id: conversation.user_id!, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                cell.userNameLabel.text = "You"
                cell.lastChatConversationLabel.text = conversation.last_message_abstract
                cell.dateLabel.text = Date.timeAgoSinceUnixTime(unix_time: conversation.last_message_date!, currentDate: Date())
            }
        }
        
        return cell
    }
}
