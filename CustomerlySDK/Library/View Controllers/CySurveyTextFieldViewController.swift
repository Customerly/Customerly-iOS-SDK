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
    var returnClosure: SurveyParamsReturn?
    var survey: CySurveyResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = base_color_template.cgColor
        textField.layer.borderWidth = 1.0
        
        textField.cyDelegate = self
        confirmButton.setTitle("confirmButton".localized(comment: "Survey View"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectedChoice(datas: CySurveyParamsRequestModel? = nil, params:SurveyParamsReturn? = nil){
        self.returnClosure = params
    }
    
    // MARK: Actions
    @IBAction func confirm(_ sender: Any) {
        textField.resignFirstResponder()
        
        if textField.text != ""{
            let surveyParams = CySurveyParamsRequestModel(JSON: [:])
            surveyParams?.survey_id = survey?.survey_id
            surveyParams?.answer = textField.text
            surveyParams?.token = CyStorage.getCyDataModel()?.token
            self.returnClosure?(surveyParams)
        }
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
