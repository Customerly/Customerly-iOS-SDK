//
//  CustomerlyNavigationController.swift
//  Customerly
//
//  Created by Paolo Musolino on 19/11/16.
//
//

import UIKit

class CustomerlyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //The chat flow support only portrait orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return UIInterfaceOrientationMask.portrait
    }
    
    
}
