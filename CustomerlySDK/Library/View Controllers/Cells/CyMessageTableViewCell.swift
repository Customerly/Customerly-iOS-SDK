//
//  CyMessageTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var leftAvatar: CyImageView!
    @IBOutlet weak var rightAvatar: CyImageView!
    @IBOutlet weak var messageTextView: CyTextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
