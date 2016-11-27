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
    var active_admins : [CyAdminModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adminsTableView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ActiveAdminsTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return active_admins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleActiveAdminCell", for: indexPath)as! SingleActiveAdminTableViewCell
    
        
        Data(contentsOf: URL(string: "")!)
        //cell.adminAvatarImageView = UIImage(data: <#T##Data#>)
        
        return cell
    }
}
