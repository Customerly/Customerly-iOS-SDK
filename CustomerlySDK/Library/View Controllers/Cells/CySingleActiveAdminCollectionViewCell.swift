//
//  CySingleActiveAdminCollectionViewCell.swift
//  Customerly

import UIKit

class CySingleActiveAdminCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adminAvatarImageView: CyImageView!
    @IBOutlet weak var adminNameLabel: CyLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adminAvatarImageView.layer.cornerRadius = adminAvatarImageView.frame.size.width/2 //Circular avatar
    }
}
