//
//  CyLabel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyLabel: UILabel {

    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.customize()
    }
    
    override func prepareForInterfaceBuilder() {
        customize()
    }
    
    func customize(){
        self.layer.masksToBounds = true
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
