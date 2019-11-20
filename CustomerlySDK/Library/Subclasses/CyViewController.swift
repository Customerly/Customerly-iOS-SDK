//
//  CyViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 28/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit
import SafariServices

public class CyViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //One Tap on view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        //Photo delegate
        imagePickerController.delegate = self
        
        // Always adopt a light interface style.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Customerly.sharedInstance.customerlyIsOpen = true
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Customerly.sharedInstance.customerlyIsOpen = false
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func hideKeyboardOnTap(){
        self.view.endEditing(true)
    }
    
    // MARK: - Load VC From Storyboard, Xib
    static func cyViewControllerFromStoryboard(storyboardName: String, vcIdentifier: String) -> UIViewController{
       
        return UIStoryboard(name: storyboardName, bundle: CyBundle.getBundle()).instantiateViewController(withIdentifier: vcIdentifier)
    }
    
    static func cyLoadNib(nibName: String) -> [AnyObject]?{
        
        return CyBundle.getBundle().loadNibNamed(nibName, owner: self, options: nil) as [AnyObject]?
    }
    
    
    //MARK: - Alerts
    func showAlert(title: String, message: String, buttonTitle: String) {
        
        self.view.endEditing(true)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, buttonTitle: String, completion: @escaping () -> ()){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { (action) -> Void in
            completion()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showAlert(title: String, message: String, buttonTitle: String, buttonCancel:String, completion: @escaping () -> (), cancel: @escaping () -> ()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { (action) -> Void in
            completion()
        }
        let cancelAction = UIAlertAction(title: buttonCancel, style: UIAlertAction.Style.cancel) { (action) -> Void in
            cancel()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(title: String, message: String, buttonTitle: String, buttonCancel:String, textFieldPlaceholder: String, completion: @escaping (String?) -> (), cancel: @escaping () -> ()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
        }
        
        let okAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { (action) -> Void in
            if let textField = alertController.textFields?.last{
                completion(textField.text)
            }
            cancel()
        }
        let cancelAction = UIAlertAction(title: buttonCancel, style: UIAlertAction.Style.cancel) { (action) -> Void in
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
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.center = loaderView.center
        loaderView.addSubview(indicator)
        view.addSubview(loaderView)
        indicator.startAnimating()
        loaderView.bringSubviewToFront(view)
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
        closeButton.setImage(UIImage(named: "close_button", in: CyBundle.getBundle(), compatibleWith: nil), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: closeButton)
        self.navigationItem.leftBarButtonItem = buttonItem
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Photos alias Image Picker
    let imagePickerController = UIImagePickerController()
    var imagePickerDelegate : CyImagePickerDelegate?
    
    //the element is useful on iPad to take the correct sourceView
    func openImagePickerActionSheet(from element: UIView){
        
        let actionSheet = UIAlertController(title: "actionSheetImagePicker_title".localized(comment:"ImagePickerActionSheet"), message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "actionSheetImagePicker_cancel".localized(comment:"ImagePickerActionSheet"), style: .cancel, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "actionSheetImagePicker_takePhoto".localized(comment:"ImagePickerActionSheet"), style: .default, handler: { (action) in
            self.shootPhoto()
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "actionSheetImagePicker_imageGallery".localized(comment:"ImagePickerActionSheet"), style: .default, handler: { (action) in
            self.photoFromLibrary(from: element)
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.popoverPresentationController?.sourceView = element
        actionSheet.popoverPresentationController?.sourceRect = element.bounds
        
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
    
    func photoFromLibrary(from element: UIView){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            
            //with this line commented, we can take from photoLibrary only photo
            //imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePickerController.modalPresentationStyle = .popover
            imagePickerController.popoverPresentationController?.sourceView = element
            imagePickerController.popoverPresentationController?.sourceRect = element.bounds
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
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var  chosenImage = UIImage()
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imagePickerDelegate?.imageFromPicker!(image: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension UIViewController{
    //MARK: Browsing recursively the tree to get the top view controller
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
    
    //MARK: - Safari VC
    func openSafariVC(url: URL){
        let safariVC = SFSafariViewController(url: url)
        if #available(iOS 10.0, *) {
            if let app_config = CyStorage.getCyDataModel()?.app_config{
                safariVC.preferredBarTintColor = app_config.widget_color != nil ? UIColor(hexString: app_config.widget_color!) : base_color_template
                safariVC.preferredControlTintColor = safariVC.preferredBarTintColor?.contrastColor()
            }
            
            if user_color_template != nil{
                safariVC.preferredBarTintColor = user_color_template
                safariVC.preferredControlTintColor = user_color_template?.contrastColor()
            }
            
        } else {
            // Fallback on earlier versions
        }
        self.present(safariVC, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
