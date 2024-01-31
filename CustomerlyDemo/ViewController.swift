//
//  ViewController.swift
//  CustomerlyDemo

import UIKit
import CustomerlySDK

class ViewController: UIViewController {
    
    @IBOutlet weak var attributeNameTextField: UITextField!
    @IBOutlet weak var attributeValueTextField: UITextField!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var companyIdTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyAttributeValueTextField: UITextField!
    @IBOutlet weak var companyAttributeNameTextField: UITextField!
    
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
        Customerly.sharedInstance.setAttributes(attributes: [attributeNameTextField.text ?? "" : attributeValueTextField.text ?? ""])
    }
    
    @IBAction func registerUser(_ sender: Any) {
        if emailTextField.text != nil{
            Customerly.sharedInstance.registerUser(email: emailTextField.text!, user_id: userIdTextField.text, name: nameTextField.text)
        }
    }
    
    @IBAction func setCompany(_ sender: Any) {
        if companyIdTextField.text != nil && companyNameTextField.text != nil {
            Customerly.sharedInstance.setCompany(company: [
                "company_id": companyIdTextField.text ?? "",
                "name": companyNameTextField.text ?? "",
                companyAttributeNameTextField.text ?? "": companyAttributeValueTextField.text ?? ""
            ])
        }
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        Customerly.sharedInstance.logoutUser()
    }
    
    @IBAction func getUpdates(_ sender: Any) {
        Customerly.sharedInstance.update(success: { 
            print("Update success")
        }) { 
            print("Update failure")
        }
    }
    
    @objc func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
}

