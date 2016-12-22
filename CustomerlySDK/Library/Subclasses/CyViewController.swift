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
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        //Photo delegate
        imagePickerController.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
    
    // MARK: - Load VC From Storyboard or Xib
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
    
    static func loadNib(nibName: String) -> [AnyObject]?{
        let podBundle = Bundle(for: self.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "CustomerlySDK", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                return bundle.loadNibNamed(nibName, owner: self, options: nil) as [AnyObject]?
            }
            else {
                assertionFailure("Could not load the bundle")
            }
            
        }
        else if let nib = podBundle.loadNibNamed(nibName, owner: self, options: nil) as [AnyObject]?{
            return nib
        }
        else{
            assertionFailure("Could not create a path to the bundle")
        }
        return nil
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
        loaderView.bringSubview(toFront: view)
        return loaderView
    }
    
    func hideLoader(loaderView: CyView?){
        loaderView?.removeFromSuperview()
    }
    
    //MARK: Dismiss VC
    func addLeftCloseButton(){
        let closeButton = UIButton(frame: CGRect(x:0, y:0, width:30, height:30))
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0)
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: closeButton)
        self.navigationItem.leftBarButtonItem = buttonItem
    }
    
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Photos alias Image Picker
    let imagePickerController = UIImagePickerController()
    var imagePickerDelegate : CyImagePickerDelegate?
    
    func openImagePickerActionSheet(){
        
        let actionSheet = UIAlertController(title: "Select a file to send", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (action) in
            self.shootPhoto()
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Image Gallery", style: .default, handler: { (action) in
            self.photoFromLibrary()
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func shootPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            present(imagePickerController, animated: true, completion: nil)
        } else {
            showAlert(title: "Error", message: "Ops, the camera is not available", buttonTitle: "OK")
        }
    }
    
    func photoFromLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePickerController.modalPresentationStyle = .popover
        present(imagePickerController, animated: true, completion: nil)
        }
        else{
            showAlert(title: "Error", message: "Ops, the photo gallery is not available", buttonTitle: "OK")
        }
    }
}

//MARK: Image Picker Delegates

@objc protocol CyImagePickerDelegate {
    @objc optional func imageFromPicker(image:UIImage?)
}

extension CyViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imagePickerDelegate?.imageFromPicker!(image: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
