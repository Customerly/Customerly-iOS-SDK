//
//  CySingleActiveAdminCollectionViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 22/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySingleActiveAdminCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adminAvatarImageView: CyImageView!
    @IBOutlet weak var adminNameLabel: CyLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adminAvatarImageView.layer.cornerRadius = adminAvatarImageView.frame.size.width/2 //Circular avatar
    }
}
