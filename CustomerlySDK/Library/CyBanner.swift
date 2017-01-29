//
//  CyBanner.swift
//  Customerly
//
//  Created by Paolo Musolino on 25/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CyBanner: CyView {
    
    @IBOutlet weak var avatarImageView: CyImageView?
    @IBOutlet weak var nameLabel: CyLabel?
    @IBOutlet weak var subtitleLabel: CyLabel?
    
    /// A block to call when the uer taps on the banner.
    open var didTapBlock: (() -> ())?
    
    var viewBanner : CyBanner?
    var initialRect = CGRect(x: 15, y: -65, width: UIScreen.main.bounds.width-30, height: 65)
    var finalRect = CGRect(x: 15, y: 30, width: UIScreen.main.bounds.width-30, height: 65)
    
    
    init(name: String?, subtitle: String? = nil, attributedSubtitle: NSAttributedString? = nil, image: UIImage? = nil){
        super.init(frame: initialRect)
        if let banner = CyViewController.cyLoadNib(nibName: "Banner")?[0] as! CyBanner?{
            viewBanner = banner
            viewBanner?.frame = CGRect(x: 0, y: 0, width: initialRect.width, height: initialRect.height)
            viewBanner?.nameLabel?.text = name
            viewBanner?.nameLabel?.textColor = base_color_template
            
            if subtitle != nil{
                viewBanner?.subtitleLabel?.text = subtitle
            }else{
                viewBanner?.subtitleLabel?.attributedText = attributedSubtitle
            }
            viewBanner?.subtitleLabel?.textColor = UIColor(hexString: "#666666")
            viewBanner?.isUserInteractionEnabled = false
            
            if viewBanner != nil && viewBanner?.avatarImageView != nil{
                viewBanner?.avatarImageView?.layer.cornerRadius = viewBanner!.avatarImageView!.frame.size.width/2
                viewBanner?.avatarImageView?.image = image
            }
            
            self.addSubview(viewBanner!)
        }
        addGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func topWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindowLevelNormal && !window.isHidden && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    func addGestureRecognizers(){
        addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(didTap(_:))))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismiss))
        swipe.direction = .up
        addGestureRecognizer(swipe)
    }
    
    func didTap(_ recognizer: UITapGestureRecognizer) {
        didTapBlock?()
        dismiss()
    }
    
    func show(view: UIView? = CyBanner.topWindow(), didTapBlock: (() -> ())? = nil){
        guard let view = view else {
            cyPrint("CyBanner. Could not find view.")
            return
        }
        self.didTapBlock = didTapBlock
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .allowUserInteraction, animations: {
            self.frame = self.finalRect
        }) { (finished) in
            let dismissDelay = 4.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(1000.0 * dismissDelay))) {
                self.dismiss()
            }
        }
    }
    
    func dismiss(){
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
                    self.alpha = 0.0
                    self.frame = self.initialRect
                }) { (finished) in
                    self.removeFromSuperview()
                }
    }
    
}
