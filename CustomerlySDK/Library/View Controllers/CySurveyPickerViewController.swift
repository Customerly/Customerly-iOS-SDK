//
//  CySurveyPickerViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 03/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySurveyPickerViewController: CyViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var confirmButton: CyButton!
    var returnClosure: SurveyParamsReturn?
    var choices: [CySurveyChoiceResponseModel] = []
    var surveyChoice: CySurveyChoiceResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        confirmButton.setTitle("confirmButton".localized(comment: "Survey View"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectedChoice(datas: CySurveyParamsRequestModel? = nil, params:SurveyParamsReturn? = nil){
        self.returnClosure = params
    }
    
    //MARK: Actions
    @IBAction func confirm(_ sender: Any) {
        if surveyChoice != nil{
            let surveyParams = CySurveyParamsRequestModel(JSON: [:])
            surveyParams?.survey_id = surveyChoice?.survey_id
            surveyParams?.choice_id = surveyChoice?.choice_id
            surveyParams?.token = CyStorage.getCyDataModel()?.token
            self.returnClosure?(surveyParams)
        }
    }
   
}

extension CySurveyPickerViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        surveyChoice = choices[row]
    }
}

extension CySurveyPickerViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row].value
    }
}
