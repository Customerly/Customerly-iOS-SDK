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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
