//
//  CyTextField.swift
//  Customerly
//
//  Created by Paolo Musolino on 27/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

@objc protocol CyTextFieldKeyboardDelegate: class{
    @objc optional func keyboardShowed(height:CGFloat)
    @objc optional func keyboardHided(height:CGFloat)
}

class CyTextField: UITextField {

    weak var keyboardDelegate: CyTextFieldKeyboardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardDelegate?.keyboardShowed!(height: keyboardSize.height)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardDelegate?.keyboardHided!(height: keyboardSize.height)
        }
    }
}
