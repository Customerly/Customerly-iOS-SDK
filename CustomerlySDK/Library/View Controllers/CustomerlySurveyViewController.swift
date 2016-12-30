//
//  CustomerlySurveyViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 30/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CustomerlySurveyViewController: CyViewController {

    //MARK: - Initialiser
    static func instantiate() -> CustomerlySurveyViewController
    {
        return self.cyViewControllerFromStoryboard(storyboardName: "CustomerlySurvey", vcIdentifier: "CustomerlySurveyViewController") as! CustomerlySurveyViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
