//
//  CyConversationTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyConversationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatarImageView: CyImageView!
    @IBOutlet weak var userNameLabel: CyLabel!
    @IBOutlet weak var lastChatConversationLabel: CyLabel!
    @IBOutlet weak var dateLabel: CyLabel!
    @IBOutlet weak var selectionLayerImageView: CyImageView!
    @IBOutlet weak var selectionLineLayerImageView: CyImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2 //Circular avatar
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func unreadConversation(unread: Bool){
        selectionLayerImageView.isHidden = !unread
        selectionLineLayerImageView.isHidden = !unread
    }
}
