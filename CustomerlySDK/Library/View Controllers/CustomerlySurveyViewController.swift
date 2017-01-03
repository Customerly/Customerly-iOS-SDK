//
//  CustomerlySurveyViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 30/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CustomerlySurveyViewController: CyViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLabel: CyLabel!
    @IBOutlet weak var surveyTitleLabel: CyLabel!
    @IBOutlet weak var surveyDescriptionLabel: CyLabel!
    
    //MARK: - Initialiser
    static func instantiate() -> CustomerlySurveyViewController
    {
        let vc = self.cyViewControllerFromStoryboard(storyboardName: "CustomerlySurvey", vcIdentifier: "CustomerlySurveyViewController") as! CustomerlySurveyViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitleLabel.text = "Survey"
        alertView.layer.cornerRadius = 4
        
        //List
        //let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyListViewController") as! CySurveyListViewController?
        
        //Picker
        //let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyPickerViewController") as! CySurveyPickerViewController
        
        //Slider
//        let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveySliderViewController") as! CySurveySliderViewController
//        surveyComponent.horizontalSlider.minimumValue = 10
//        surveyComponent.horizontalSlider.maximumValue = 100
//        surveyComponent.minLabel.text = "10"
//        surveyComponent.maxLabel.text = "100"
        
        //Stars
        let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyStarsViewController") as! CySurveyStarsViewController
        
        
        
    }
    
    @discardableResult
    func loadSurveyViewControllerComponent(viewControllerIdentifier: String) -> (UIViewController?){
        
        let controller = CyViewController.cyViewControllerFromStoryboard(storyboardName: "CustomerlySurvey", vcIdentifier: viewControllerIdentifier)
        addChildViewController(controller)
        
        if let aView = controller.view{
            alertView.addSubview(aView)
            aView.translatesAutoresizingMaskIntoConstraints = false
            aView.preservesSuperviewLayoutMargins = true
            
            alertView.addConstraints([
                NSLayoutConstraint(item: aView, attribute: .leading, relatedBy: .equal, toItem: alertView, attribute: .leading, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: aView, attribute: .trailing, relatedBy: .equal, toItem: alertView, attribute: .trailing, multiplier: 1, constant: -8),
                NSLayoutConstraint(item: aView, attribute: .top, relatedBy: .equal, toItem: surveyDescriptionLabel, attribute: .bottom, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: aView, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1, constant: -8)
                ])
            
            return (controller)
        }
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions
    @IBAction func back(_ sender: Any) {
        let surveyVC = CustomerlySurveyViewController.instantiate()
        surveyVC.view.backgroundColor = .red
        surveyVC.surveyTitleLabel.text = "ciao"
        self.dismissVC()
        self.presentingViewController?.present(surveyVC, animated: true, completion: nil)
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismissVC()
    }
}
