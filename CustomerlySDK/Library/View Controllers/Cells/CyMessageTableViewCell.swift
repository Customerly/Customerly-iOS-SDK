//
//  CyMessageTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit
import Kingfisher

class CyMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adminAvatar: CyImageView!
    @IBOutlet weak var userAvatar: CyImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: CyTextView!
    @IBOutlet weak var dateLabel: CyLabel!
    
    @IBOutlet var messageViewLeftConstraint: NSLayoutConstraint?
    @IBOutlet var messageViewRightConstraint: NSLayoutConstraint?
    @IBOutlet weak var attachmentsStackView: CyStackView?
    @IBOutlet weak var attachmentsStackViewHeightConstraint: NSLayoutConstraint?
    var vcThatShowThisCell : CyViewController?
    
    var imagesAttachments : [String] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 8.0
        messageTextView.textContainerInset = UIEdgeInsetsMake(2, 0, -12, 0) //remove padding
        adminAvatar.layer.cornerRadius = adminAvatar.frame.size.width/2 //Circular avatar for admin
        userAvatar.layer.cornerRadius = userAvatar.frame.size.width/2 //Circular avatar for user
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAdminVisual(bubbleColor: UIColor? = UIColor(hexString: "#ECEFF1")){
        messageTextView.textAlignment = .left
        userAvatar.isHidden = true
        adminAvatar.isHidden = false
        messageViewRightConstraint?.isActive = false
        messageViewLeftConstraint?.isActive = true
        messageView.backgroundColor = bubbleColor
    }
    
    func setUserVisual(bubbleColor: UIColor? = UIColor(hexString: "#01B0FF")){
        userAvatar.isHidden = false
        adminAvatar.isHidden = true
        messageTextView.textAlignment = .left
        messageViewRightConstraint?.isActive = true
        messageViewLeftConstraint?.isActive = false
        messageView.backgroundColor = bubbleColor
    }
    
    func cellContainsImages(configForImages: Bool){
        guard attachmentsStackView != nil else {
            return
        }
        for view in attachmentsStackView!.arrangedSubviews{
            attachmentsStackView?.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for url in imagesAttachments{
            let imageViewAttachment = CyImageView()
            imageViewAttachment.kf.indicatorType = .activity
            imageViewAttachment.kf.setImage(with: URL(string: url))
            imageViewAttachment.contentMode = .scaleAspectFill
            imageViewAttachment.clipsToBounds = true
            imageViewAttachment.isUserInteractionEnabled = true
            let imageViewHeightConstraint = NSLayoutConstraint(item: imageViewAttachment, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150)
            imageViewHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            imageViewAttachment.addConstraint(imageViewHeightConstraint)
            imageViewAttachment.touchUpInside(action: { [weak self] in
                if imageViewAttachment.image != nil{
                    let galleryVC = CustomerlyGalleryViewController.instantiate()
                    galleryVC.image = imageViewAttachment.image
                    self?.vcThatShowThisCell?.present(galleryVC, animated: true, completion: nil)
                }
            })
            attachmentsStackView?.addArrangedSubview(imageViewAttachment)
        }
    }
}