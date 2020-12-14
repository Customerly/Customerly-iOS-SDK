//
//  CustomerlyGalleryViewController.swift
//  Customerly

import UIKit

class CustomerlyGalleryViewController: CyViewController {

    var image : UIImage?
    @IBOutlet weak var imageGallery: CyImageView!
    
    //MARK: - Initialiser
    static func instantiate() -> CustomerlyGalleryViewController
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlyImageGallery", vcIdentifier: "CustomerlyGalleryViewController") as! CustomerlyGalleryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGallery.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
