//
//  CySurveySliderViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 03/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySurveySliderViewController: CyViewController {

    @IBOutlet weak var minLabel: CyLabel!
    @IBOutlet weak var maxLabel: CyLabel!
    @IBOutlet weak var horizontalSlider: UISlider!
    @IBOutlet weak var confirmButton: CyButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: Actions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        confirmButton.setTitle("Confirm " + "\(Int(sender.value))", for: .normal)
    }
    
    @IBAction func confirm(_ sender: Any) {
        
        //return Int(horizontalSlider.value)
    }

}

