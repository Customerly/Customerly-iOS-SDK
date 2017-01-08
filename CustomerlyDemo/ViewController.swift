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
        
        Customerly.sharedInstance.realTimeMessages { (htmlMessage) in
            print("OH OH OH, A NEW MESSAGE!!", htmlMessage ?? "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    @IBAction func openChat(_ sender: Any) {
        Customerly.sharedInstance.openSupport(from: self)
    }
    
    @IBAction func addAttribute(_ sender: Any) {
        Customerly.sharedInstance.setAttributes(attributes: [attributeNameTextField.text ?? "" : attributeValueTextField.text ?? ""])
    }
    
    @IBAction func registerUser(_ sender: Any) {
        if emailTextField.text != nil{
            Customerly.sharedInstance.registerUser(email: emailTextField.text!, user_id: userIdTextField.text, name: nameTextField.text)
        }
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        Customerly.sharedInstance.logoutUser()
    }
    
    @IBAction func openSurveyIfAvailable(_ sender: Any) {
        
        Customerly.sharedInstance.openSurvey(from: self, onShow: {
            print("Survey showed")
        }) { (surveyDismiss) in
            if surveyDismiss == .postponed{
                print("Survey postponed")
            }
            else if surveyDismiss == .completed{
                print("Survey completed")
            }
            else if surveyDismiss == .rejected{
                print("Survey rejected")
            }
        }
        
        //Or simply
        //Customerly.sharedInstance.openSurvey(from: self)
    }
    
    @IBAction func getUpdates(_ sender: Any) {
        Customerly.sharedInstance.update(success: { (newSurvey, newMessage) in
            print("Update success")
            print("New survey?", "\(newSurvey)", " - New message?", "\(newMessage)")
            
            if newMessage == true{
                Customerly.sharedInstance.openLastSupportConversation(from: self)
            }
        }) {
            print("Update failure")
        }
    }
    
    func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
}

