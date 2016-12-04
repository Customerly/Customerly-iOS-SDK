//
//  CySingleActiveAdminTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 26/11/16.
//
//

import UIKit

class CySingleActiveAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var adminAvatarImageView: CyImageView!
    @IBOutlet weak var adminNameLabel: CyLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adminAvatarImageView.layer.cornerRadius = adminAvatarImageView.frame.size.width/2 //Circular avatar
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
