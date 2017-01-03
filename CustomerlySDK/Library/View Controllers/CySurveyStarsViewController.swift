//
//  CySurveyStarsViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 03/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySurveyStarsViewController: CyViewController {

    @IBOutlet weak var starButton1: CyButton!
    @IBOutlet weak var starButton2: CyButton!
    @IBOutlet weak var starButton3: CyButton!
    @IBOutlet weak var starButton4: CyButton!
    @IBOutlet weak var starButton5: CyButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectStars(stars: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectStars(stars: Int){
        for starButton in [starButton1, starButton2, starButton3, starButton4, starButton5]{
            starButton?.alpha = 0.5
            if let tag = starButton?.tag{
                if tag <= stars{
                    starButton?.alpha = 1.0
                }
            }
        }
    }
    
    // MARK: Actions
    @IBAction func selectStars(_ sender: UIButton) {
        selectStars(stars: sender.tag)
    }

}
