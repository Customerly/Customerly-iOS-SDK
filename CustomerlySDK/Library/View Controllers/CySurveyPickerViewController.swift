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
    
    var pickerData : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    @IBAction func confirm(_ sender: Any) {
    }

}

extension CySurveyPickerViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension CySurveyPickerViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
