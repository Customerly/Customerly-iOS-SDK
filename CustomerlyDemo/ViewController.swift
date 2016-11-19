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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Customerly.sharedInstance.ping()
        Customerly.sharedInstance.trackEvent(event: "an_event")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    @IBAction func openChat(_ sender: Any) {
        Customerly.sharedInstance.openSupport(from: self)
    }
    
}

