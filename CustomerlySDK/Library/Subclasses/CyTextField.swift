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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async(){
                self.cyDelegate?.keyboardShowed!(height: keyboardSize.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async(){
                self.cyDelegate?.keyboardHided!(height: keyboardSize.height)
            }
        }
    }
    
    @objc func textFieldDidChange(){
        self.cyDelegate?.isTyping!(typing: true)
        textTimer?.invalidate()
        textTimer = nil
        textTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(stopTextDidChange), userInfo: nil, repeats: false)
    }
    
    @objc func stopTextDidChange(){
        self.cyDelegate?.isTyping!(typing: false)
    }
    
}
