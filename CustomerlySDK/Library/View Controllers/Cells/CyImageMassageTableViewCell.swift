//
//  CyImageMassageTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 26/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyImageMassageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messageImageView: CyImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
