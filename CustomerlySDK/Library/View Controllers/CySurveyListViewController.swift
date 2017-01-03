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
    
    var showRadioButtons = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension CySurveyListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CySurveyListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (showRadioButtons == false ? "surveyButtonCell" : "radioButtonCell"), for: indexPath) as! CySurveyButtonTableViewCell
        
        tableViewHeightConstraint.constant = tableView.contentSize.height
        
        return cell
    }
}
