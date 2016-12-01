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
        
        self.view.endEditing(true)
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
    
    func showAlertWithTextField(title: String, message: String, buttonTitle: String, buttonCancel:String, textFieldPlaceholder: String, completion: @escaping (String?) -> (), cancel: @escaping () -> ()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
        }
        
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            if let textField = alertController.textFields?.last{
                completion(textField.text)
            }
            cancel()
        }
        let cancelAction = UIAlertAction(title: buttonCancel, style: UIAlertActionStyle.cancel) { (action) -> Void in
            cancel()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Loader
    func showLoader(view: UIView) -> CyView{
        //LoaderView with view size, with indicator placed on center of loaderView
        let loaderView = CyView(frame: view.bounds)
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.center = loaderView.center
        loaderView.addSubview(indicator)
        view.addSubview(loaderView)
        indicator.startAnimating()
        return loaderView
    }
    
    func hideLoader(loaderView: CyView?){
        loaderView?.removeFromSuperview()
    }
    
}


