//
//  ActiveAdminsTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 26/11/16.
//
//

import UIKit

class ActiveAdminsTableViewCell: UITableViewCell {

    @IBOutlet weak var adminsTableView: UITableView!
    @IBOutlet weak var lastActivityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
