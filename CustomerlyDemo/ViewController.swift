//
//  ViewController.swift
//  CustomerlyDemo
//
//  Created by Paolo Musolino on 19/11/16.
//
//

import UIKit
import CustomerlySDK

class ViewController: UIViewController {
    
    @IBOutlet weak var attributeNameTextField: UITextField!
    @IBOutlet weak var attributeValueTextField: UITextField!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard on tap on view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnTap))
        self.view.addGestureRecognizer(tapGesture)
        
        //track an event
        Customerly.sharedInstance.trackEvent(event: "this_is_an_event")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    @IBAction func openChat(_ sender: Any) {
        Customerly.sharedInstance.openSupport(from: self)
    }
    
    @IBAction func addAttribute(_ sender: Any) {
        Customerly.sharedInstance.update(attributes: [attributeNameTextField.text ?? "" : attributeValueTextField.text ?? ""])
    }
    
    @IBAction func registerUser(_ sender: Any) {
        if emailTextField.text != nil{
            Customerly.sharedInstance.registerUser(email: emailTextField.text!, user_id: userIdTextField.text, name: nameTextField.text)
        }
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        Customerly.sharedInstance.logoutUser()
    }
    
    func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
}

