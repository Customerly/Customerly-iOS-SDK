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
        
        let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyListViewController") as? (UIView?, CySurveyListViewController?)
//        if let aView = surveyComponent?.0{
//            aView.addConstraint(NSLayoutConstraint(item: aView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1000))
//        }
        
        
    }
    
    @discardableResult
    func loadSurveyViewControllerComponent(viewControllerIdentifier: String) -> (view:UIView?, viewController:UIViewController?){
        
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
            
            return (aView, controller)
        }
        return (nil, nil)
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
