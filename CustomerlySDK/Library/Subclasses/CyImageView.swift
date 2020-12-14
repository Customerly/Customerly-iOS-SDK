//
//  CyImageView.swift
//  Customerly

import UIKit

class CyImageView: UIImageView {

    private var action: (() -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        addTapGestureRecognizer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    //MARK: Action Closure
    func touchUpInside(action: (() -> Void)? = nil){
        self.action = action
    }
    
    @objc func viewTapped(sender: CyImageView? = nil) {
        self.action?()
    }

}
