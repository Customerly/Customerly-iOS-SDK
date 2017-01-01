//
//  CySurveyButtonTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySurveyButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var button: CyButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
