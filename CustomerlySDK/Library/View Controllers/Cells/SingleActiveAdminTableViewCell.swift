//
//  SingleActiveAdminTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 26/11/16.
//
//

import UIKit

class SingleActiveAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var adminAvatarImageView: UIImageView!
    @IBOutlet weak var adminNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
