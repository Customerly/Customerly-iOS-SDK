//
//  CyChatStartVC.swift
//  Customerly
//
//  Created by Paolo Musolino on 11/11/16.
//
//

import UIKit

open class CustomerlyChatStartVC: UIViewController {

   
    
    //MARK: - Initialiser
    open static func instantiate() -> CustomerlyChatStartVC
    {
        return self.viewControllerFromStoryboard()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LoadVCFromStoryboard
    static func viewControllerFromStoryboard() -> CustomerlyChatStartVC{
        let podBundle = Bundle(for: self.classForCoder())
        
        if let bundleURL = podBundle.url(forResource: "CustomerlySDK", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                return UIStoryboard(name: "CustomerlyChat", bundle: bundle).instantiateViewController(withIdentifier: "CustomerlyChatStartVC") as! CustomerlyChatStartVC
            }
            else {
                assertionFailure("Could not load the bundle")
            }
            
        }
        
        return UIStoryboard(name: "CustomerlyChat", bundle: podBundle).instantiateViewController(withIdentifier: "CustomerlyChatStartVC") as! CustomerlyChatStartVC
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
