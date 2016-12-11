//
//  CyMessageTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var adminAvatar: CyImageView!
    @IBOutlet weak var userAvatar: CyImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: CyTextView!
    @IBOutlet var messageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewRightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 4.0
        messageTextView.textContainerInset = UIEdgeInsetsMake(2, 0, -15, 0) //remove padding
        adminAvatar.layer.cornerRadius = adminAvatar.frame.size.width/2 //Circular avatar for admin
        userAvatar.layer.cornerRadius = userAvatar.frame.size.width/2 //Circular avatar for user
        self.backgroundColor = UIColor.clear
        
        if let app_config = CyStorage.getCyDataModel()?.app_config{
            messageView.backgroundColor = app_config.widget_color != nil ? UIColor(hexString: app_config.widget_color!) : base_color_template
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setAdminVisual(){
        
        messageTextView.textAlignment = .left
        userAvatar.isHidden = true
        adminAvatar.isHidden = false
        messageViewRightConstraint.isActive = false
        messageViewLeftConstraint.isActive = true
    }
    
    func setUserVisual(){
        userAvatar.isHidden = false
        adminAvatar.isHidden = true
        messageTextView.textAlignment = .right
        messageViewRightConstraint.isActive = true
        messageViewLeftConstraint.isActive = false
    }
}
