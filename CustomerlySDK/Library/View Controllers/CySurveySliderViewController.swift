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
    var returnClosure: SurveyParamsReturn?
    var survey: CySurveyResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setTitle("confirmButton".localized(comment: "Survey View"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectedChoice(datas: CySurveyParamsRequestModel? = nil, params:SurveyParamsReturn? = nil){
        self.returnClosure = params
    }

    //MARK: Actions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        confirmButton.setTitle(String.localizedStringWithFormat("confirmSliderButton %d".localized(comment: "Survey View"),  Int(sender.value)), for: .normal)
    }
    
    @IBAction func confirm(_ sender: Any) {
        let surveyParams = CySurveyParamsRequestModel(JSON: [:])
        surveyParams?.survey_id = survey?.survey_id
        surveyParams?.answer = "\(Int(horizontalSlider.value))"
        surveyParams?.token = CyStorage.getCyDataModel()?.token
        self.returnClosure?(surveyParams)
    }

}

