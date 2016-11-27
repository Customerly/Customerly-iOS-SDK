//
//  CyView.swift
//  Customerly
//
//  Created by Paolo Musolino on 27/11/16.
//
//

import UIKit

@IBDesignable
class CyView: UIView {

    @IBInspectable var borderColor : UIColor = UIColor.clear
    @IBInspectable var borderWidth : CGFloat = 0
    @IBInspectable var cornerRadius : CGFloat = 0
    @IBInspectable var shadowColor : UIColor = UIColor.clear
    @IBInspectable var shadowOpacity : Float = 0
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowRadius : CGFloat = 0
   

    override func layoutSubviews() {
        super.layoutSubviews()
        self.customize()
    }
    
    override func prepareForInterfaceBuilder() {
        customize()
    }
    
    func customize(){
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }

}
