//
//  CyActiveAdminsTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 26/11/16.
//
//

import UIKit
import Kingfisher

class CyActiveAdminsTableViewCell: UITableViewCell {

    @IBOutlet weak var adminsCollectionView: CyCollectionView!
    @IBOutlet weak var lastActivityLabel: CyLabel!
    @IBOutlet weak var welcomeMessageLabel: CyLabel!
    var active_admins : [CyAdminModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adminsCollectionView.dataSource = self
        adminsCollectionView.delegate = self
        
        adminsCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension CyActiveAdminsTableViewCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return active_admins?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleAdminCell", for: indexPath) as! CySingleActiveAdminCollectionViewCell
        
        cell.adminAvatarImageView.kf.setImage(with: adminImageURL(id: active_admins![indexPath.row].account_id!, pxSize: 100), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        cell.adminNameLabel.text = active_admins?[indexPath.row].name
        
        return cell
    }
    
}

extension CyActiveAdminsTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //40 is the lateral margin of the collectionview from bounds
        return CGSize(width: (UIScreen.main.bounds.width-40)/CGFloat(active_admins?.count ?? 1), height: collectionView.frame.size.height)
    }
}
