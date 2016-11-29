//
//  CyViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 28/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //One Tap on view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnTap))
        self.view.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
    
    // MARK: - Load VC From Storyboard
    static func cyViewControllerFromStoryboard(storyboardName: String, vcIdentifier: String) -> UIViewController{
        let podBundle = Bundle(for: self.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "CustomerlySDK", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                return UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: vcIdentifier)
            }
            else {
                assertionFailure("Could not load the bundle")
            }
            
        }
        
        return UIStoryboard(name: "CustomerlyChat", bundle: podBundle).instantiateViewController(withIdentifier: vcIdentifier)
    }

    //MARK: - Alerts
    func showAlert(title: String, message: String, buttonTitle: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(title: String, message: String, buttonTitle: String, completion: @escaping () -> ()){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            completion()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showAlert(title: String, message: String, buttonTitle: String, buttonCancel:String, completion: @escaping () -> (), cancel: @escaping () -> ()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            completion()
        }
        let cancelAction = UIAlertAction(title: buttonCancel, style: UIAlertActionStyle.cancel) { (action) -> Void in
            cancel()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


