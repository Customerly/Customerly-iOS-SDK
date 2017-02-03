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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Customerly.sharedInstance.customerlyIsOpen = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Customerly.sharedInstance.customerlyIsOpen = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
    
    // MARK: - Load VC From Storyboard, Xib
    static func cyViewControllerFromStoryboard(storyboardName: String, vcIdentifier: String) -> UIViewController{
        let podBundle = Bundle(for: Customerly.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "CustomerlySDK", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                return UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: vcIdentifier)
            }
            else {
                assertionFailure("Could not load the bundle")
            }
            
        }
        
        return UIStoryboard(name: storyboardName, bundle: podBundle).instantiateViewController(withIdentifier: vcIdentifier)
    }
    
    static func cyLoadNib(nibName: String) -> [AnyObject]?{
        let podBundle = Bundle(for: Customerly.classForCoder())
        
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
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x:0, y:0, width:15, height:15)
        closeButton.tintColor = UIColor.white
        closeButton.setImage(UIImage(named: "close_button", in: Bundle(for: Customerly.classForCoder()), compatibleWith: nil), for: .normal)
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
        
        let actionSheet = UIAlertController(title: "actionSheetImagePicker_title".localized(comment:"ImagePickerActionSheet"), message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "actionSheetImagePicker_cancel".localized(comment:"ImagePickerActionSheet"), style: .cancel, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "actionSheetImagePicker_takePhoto".localized(comment:"ImagePickerActionSheet"), style: .default, handler: { (action) in
            self.shootPhoto()
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "actionSheetImagePicker_imageGallery".localized(comment:"ImagePickerActionSheet"), style: .default, handler: { (action) in
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
            showAlert(title: "actionSheetImagePicker_error".localized(comment:"ImagePickerActionSheet"), message: "actionSheetImagePicker_error_cameraNotAvailable".localized(comment:"ImagePickerActionSheet"), buttonTitle: "actionSheetImagePicker_confirm".localized(comment:"ImagePickerActionSheet"))
        }
    }
    
    func photoFromLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            //with this line commented, we can take from photoLibrary only photo
            //imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePickerController.modalPresentationStyle = .popover
            present(imagePickerController, animated: true, completion: nil)
        }
        else{
            showAlert(title: "actionSheetImagePicker_error".localized(comment:"ImagePickerActionSheet"), message:"actionSheetImagePicker_error_galleryNotAvailable".localized(comment:"ImagePickerActionSheet"), buttonTitle: "actionSheetImagePicker_error".localized(comment:"actionSheetImagePicker_confirm"))
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
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePickerDelegate?.imageFromPicker!(image: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Browsing recursively the tree to get the top view controller
extension UIViewController{
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
