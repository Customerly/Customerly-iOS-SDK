//
//  CySurveyListViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import UIKit

class CySurveyListViewController: CyViewController {
    
    @IBOutlet weak var tableView: CyTableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var returnClosure: SurveyParamsReturn?
    var choices: [CySurveyChoiceResponseModel] = []
    var showRadioButtons = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectedChoice(datas: CySurveyParamsRequestModel? = nil, params:SurveyParamsReturn? = nil){
        self.returnClosure = params
    }
    
}

extension CySurveyListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let surveyParams = CySurveyParamsRequestModel(JSON: [:])
        surveyParams?.survey_id = choices[indexPath.row].survey_id
        surveyParams?.choice_id = choices[indexPath.row].choice_id
        surveyParams?.token = CyStorage.getCyDataModel()?.token
        self.returnClosure?(surveyParams)
    }
}

extension CySurveyListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (showRadioButtons == false ? "surveyButtonCell" : "radioButtonCell"), for: indexPath) as! CySurveyButtonTableViewCell
        
        cell.button.setTitle(choices[indexPath.row].value, for: .normal)
        tableViewHeightConstraint.constant = tableView.contentSize.height
        return cell
    }
}
