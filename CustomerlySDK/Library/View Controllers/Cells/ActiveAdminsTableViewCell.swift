//
//  ActiveAdminsTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 26/11/16.
//
//

import UIKit
import Kingfisher

class ActiveAdminsTableViewCell: UITableViewCell {

    @IBOutlet weak var adminsTableView: UITableView!
    @IBOutlet weak var lastActivityLabel: UILabel!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    var active_admins : [CyAdminModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adminsTableView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension ActiveAdminsTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return active_admins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleActiveAdminCell", for: indexPath)as! SingleActiveAdminTableViewCell
    
        cell.adminAvatarImageView.kf.setImage(with: adminImageURL(id: active_admins![indexPath.row].account_id!, pxSize: 250), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        cell.adminNameLabel.text = active_admins?[indexPath.row].name
        
        heightTableViewConstraint.constant = adminsTableView.contentSize.height
        
        return cell
    }
}
