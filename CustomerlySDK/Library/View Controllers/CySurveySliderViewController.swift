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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectedChoice(datas: CySurveyParamsRequestModel? = nil, params:SurveyParamsReturn? = nil){
        self.returnClosure = params
    }

    //MARK: Actions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        confirmButton.setTitle("Confirm " + "\(Int(sender.value))", for: .normal)
    }
    
    @IBAction func confirm(_ sender: Any) {
        let surveyParams = CySurveyParamsRequestModel(JSON: [:])
        surveyParams?.survey_id = survey?.survey_id
        surveyParams?.answer = "\(Int(horizontalSlider.value))"
        if let dataStored = CyStorage.getCyDataModel(){
            surveyParams?.settings?.user_id = dataStored.user?.user_id
            surveyParams?.settings?.email = dataStored.user?.email
            surveyParams?.settings?.name = dataStored.user?.name
            surveyParams?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            surveyParams?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            surveyParams?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
        }
        self.returnClosure?(surveyParams)
    }

}

