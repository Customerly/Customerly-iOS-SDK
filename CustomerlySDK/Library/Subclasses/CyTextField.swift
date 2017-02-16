//
//  CyTextField.swift
//  Customerly
//
//  Created by Paolo Musolino on 27/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

@objc protocol CyTextFieldDelegate: class{
    @objc optional func keyboardShowed(height:CGFloat)
    @objc optional func keyboardHided(height:CGFloat)
    @objc optional func isTyping(typing: Bool)
}

class CyTextField: UITextField {

    weak var cyDelegate: CyTextFieldDelegate?
    var textTimer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async(){
                self.cyDelegate?.keyboardShowed!(height: keyboardSize.height)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async(){
                self.cyDelegate?.keyboardHided!(height: keyboardSize.height)
            }
        }
    }
    
    func textFieldDidChange(){
        self.cyDelegate?.isTyping!(typing: true)
        textTimer?.invalidate()
        textTimer = nil
        textTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(stopTextDidChange), userInfo: nil, repeats: false)
    }
    
    func stopTextDidChange(){
        self.cyDelegate?.isTyping!(typing: false)
    }
    
}
