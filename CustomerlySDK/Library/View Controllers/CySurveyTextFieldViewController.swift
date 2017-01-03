//
//  CySurveyTextFieldViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 03/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySurveyTextFieldViewController: CyViewController {

    @IBOutlet weak var textField: CyTextField!
    @IBOutlet weak var confirmButton: CyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = base_color_template.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.cyDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: Actions
    @IBAction func confirm(_ sender: Any) {
        textField.resignFirstResponder()
    }

}

extension CySurveyTextFieldViewController: CyTextFieldDelegate{
    func keyboardShowed(height: CGFloat) {
        //TODO: calculate true different between alert and keyboard + if check
        var frame = self.parent?.view.frame
        frame?.origin.y -= 50
        self.parent?.view.frame = frame!
    }
    
    func keyboardHided(height: CGFloat) {
        //TODO: alert repositioned to zero + if check
        var frame = self.parent?.view.frame
        frame?.origin.y = 0
        self.parent?.view.frame = frame!
    }
    
    func isTyping(typing: Bool) {
    }
}
