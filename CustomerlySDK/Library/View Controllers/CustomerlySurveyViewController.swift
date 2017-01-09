//
//  CustomerlySurveyViewController.swift
//  Customerly
//
//  Created by Paolo Musolino on 30/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

typealias SurveyParamsReturn = ((CySurveyParamsRequestModel?) -> Void)

public enum CySurveyDismiss: Int {
    case postponed = 0 //survey closed without invalidation (tap out of alert)
    case completed = 1 //survey closed after that user completed it (user closed survey in "thank you message" step)
    case rejected = 2 //survey closed and reject (user closed survey before "thank you message" step)
}

enum CySurveyType: Int {
    case buttons = 0
    case radiobuttons = 1
    case picker = 2
    case slider = 3
    case stars = 4
    case textnumber = 5
    case textbox = 6
    case textarea = 7
}

class CustomerlySurveyViewController: CyViewController {
    
    @IBOutlet weak var backgroundAlertView: CyImageView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLabel: CyLabel!
    @IBOutlet weak var surveyTitleLabel: CyLabel!
    @IBOutlet weak var surveyDescriptionLabel: CyLabel!
    var survey: CySurveyResponseModel?
    var surveyOnClosure: ((Void) -> Void)?
    var surveyOnDismiss: ((CySurveyDismiss?) -> Void)?
    var firstSurveyVC: CustomerlySurveyViewController?
    
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
        
        /*
         * firstSurveyVC is a reference to the first survey VC. Is useful to send surveyOnDismiss messages
         * If no firstSurveyVC is allocated, the firstSurveyVC will be the current survey VC
         * firstSurveyVC will be passed to the next surveyVC
         */
        if firstSurveyVC == nil{
            firstSurveyVC = self
        }
        
        headerTitleLabel.text = "Survey".localized(comment: "Survey View")
        alertView.layer.cornerRadius = 4
        
        //If step zero, hide backButton
        if survey?.step == 0{
            backButton.isHidden = true
        }
        
        //One Tap on background view to dismiss survey
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVCWithoutInvalidation))
        tapGesture.cancelsTouchesInView = false
        backgroundAlertView.addGestureRecognizer(tapGesture)
        
        showSurvey()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if survey != nil{
            surveyOnClosure?()
        }
    }
    
    func showSurvey(){
        
        guard survey != nil else {
            dismissVC()
            return
        }
        
        surveySeenAPI()
        
        if let surveyModel = survey{
            updateStoredSurvey()
            
            if let questionTitle = surveyModel.question_title{
                surveyTitleLabel.text = questionTitle
            }
            if let questionSubtitle = surveyModel.question_subtitle{
                surveyDescriptionLabel.text = questionSubtitle
            }
            
            //No more survey, then show html thank you message
            if surveyModel.question_type == nil{
                backButton.isHidden = true
                surveyTitleLabel.attributedText = surveyModel.thankyou_text?.attributedStringFromHTML(font: UIFont.systemFont(ofSize: 14.0), color: UIColor.black)
                alertView.addConstraints([
                    NSLayoutConstraint(item: surveyTitleLabel, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1, constant: -8)
                    ])
                return
            }
            
            //Show a view container based on question type
            switch surveyModel.question_type {
            case .some(CySurveyType.buttons.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyListViewController") as! CySurveyListViewController
                surveyComponent.choices = surveyModel.choices ?? []
                surveyComponent.tableView.reloadData()
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.radiobuttons.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyListViewController") as! CySurveyListViewController
                surveyComponent.choices = surveyModel.choices ?? []
                surveyComponent.showRadioButtons = true
                surveyComponent.tableView.reloadData()
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.picker.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyPickerViewController") as! CySurveyPickerViewController
                surveyComponent.choices = surveyModel.choices ?? []
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.slider.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveySliderViewController") as! CySurveySliderViewController
                surveyComponent.horizontalSlider.minimumValue = Float(surveyModel.limit_from ?? 0)
                surveyComponent.horizontalSlider.maximumValue = Float(surveyModel.limit_to ?? 2)
                surveyComponent.minLabel.text = surveyModel.limit_from != nil ? "\(surveyModel.limit_from!)" : ""
                surveyComponent.maxLabel.text = surveyModel.limit_to != nil ? "\(surveyModel.limit_to!)" : ""
                surveyComponent.survey = survey
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.stars.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyStarsViewController") as! CySurveyStarsViewController
                surveyComponent.survey = survey
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.textnumber.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyTextFieldViewController") as! CySurveyTextFieldViewController
                surveyComponent.textField.keyboardType = .numberPad
                surveyComponent.survey = survey
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.textbox.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyTextFieldViewController") as! CySurveyTextFieldViewController
                surveyComponent.survey = survey
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            case .some(CySurveyType.textarea.rawValue):
                let surveyComponent = loadSurveyViewControllerComponent(viewControllerIdentifier: "CySurveyTextFieldViewController") as! CySurveyTextFieldViewController
                surveyComponent.survey = survey
                surveyComponent.selectedChoice(params: { (surveyParams) in
                    self.submitSurveyAPI(params: surveyParams)
                })
                break
            default:
                dismissVC()
                return
            }
        }
    }
    
    /*
     * Load survey container view
     *
     */
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
    
    //MARK: Closures
    func onShow(on: (() -> Void)?){
        self.surveyOnClosure = on
    }
    
    func onDismiss(onDis: ((CySurveyDismiss?) -> Void)?){
        self.surveyOnDismiss = onDis
    }
    
    //MARK: APIs
    func submitSurveyAPI(params: CySurveyParamsRequestModel?){
        let hud = showLoader(view: alertView)
        CyDataFetcher.sharedInstance.submitSurvey(surveyRequestModel: params, completion: { (surveyResponse) in
            self.hideLoader(loaderView: hud)
            self.showNextQuestion(surveyResponse: surveyResponse)
        }) { (error) in
            self.hideLoader(loaderView: hud)
        }
    }
    
    func surveySeenAPI(){
        if survey != nil && survey?.seen_at == nil{
            let surveyParams = CySurveyParamsRequestModel(JSON: [:])
            surveyParams?.survey_id = survey?.survey_id
            if let dataStored = CyStorage.getCyDataModel(){
                surveyParams?.settings?.user_id = dataStored.user?.user_id
                surveyParams?.settings?.email = dataStored.user?.email
                surveyParams?.settings?.name = dataStored.user?.name
                surveyParams?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
                surveyParams?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
                surveyParams?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
            }
            
            CyDataFetcher.sharedInstance.surveySeen(surveyRequestModel: surveyParams, completion: {
                
            }, failure: { (error) in
                
            })
        }
    }
    
    func surveyBackAPI(){
        let surveyParams = CySurveyParamsRequestModel(JSON: [:])
        surveyParams?.survey_id = survey?.survey_id
        if let dataStored = CyStorage.getCyDataModel(){
            surveyParams?.settings?.user_id = dataStored.user?.user_id
            surveyParams?.settings?.email = dataStored.user?.email
            surveyParams?.settings?.name = dataStored.user?.name
            surveyParams?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            surveyParams?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            surveyParams?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
        }
        
        let hud = showLoader(view: alertView)
        CyDataFetcher.sharedInstance.surveyBack(surveyRequestModel: surveyParams, completion: { (surveyResponse) in
            self.hideLoader(loaderView: hud)
            self.showNextQuestion(surveyResponse: surveyResponse)
        }) { (error) in
            self.hideLoader(loaderView: hud)
        }
    }
    
    func surveyRejectAPI(){
        let surveyParams = CySurveyParamsRequestModel(JSON: [:])
        surveyParams?.survey_id = survey?.survey_id
        if let dataStored = CyStorage.getCyDataModel(){
            surveyParams?.settings?.user_id = dataStored.user?.user_id
            surveyParams?.settings?.email = dataStored.user?.email
            surveyParams?.settings?.name = dataStored.user?.name
            surveyParams?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            surveyParams?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            surveyParams?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
        }
        
        CyDataFetcher.sharedInstance.surveyReject(surveyRequestModel: surveyParams, completion: {
        }) { (error) in
        }
        
        //If the survey contain only the "thank you message", dismiss with completion, else with rejection
        survey?.question_type == nil ? dismissVCWithCompletion() : dismissVCWithRejection()
        removeStoredSurvey()
    }
    
    //MARK: Actions
    func showNextQuestion(surveyResponse: CySurveyResponseModel?){
        if let response = surveyResponse{
            let surveyVC = CustomerlySurveyViewController.instantiate()
            surveyVC.firstSurveyVC = firstSurveyVC
            surveyVC.survey = response
            
            self.presentingViewController?.dismiss(animated: false, completion: nil)
            self.presentingViewController?.present(surveyVC, animated: true, completion:nil)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        surveyBackAPI()
    }
    
    @IBAction func close(_ sender: Any) {
        surveyRejectAPI()
    }
    
    //Survey dismiss
    func dismissVCWithoutInvalidation(){
        firstSurveyVC?.surveyOnDismiss?(CySurveyDismiss.postponed)
        dismissVC()
    }
    
    func dismissVCWithCompletion(){
        firstSurveyVC?.surveyOnDismiss?(CySurveyDismiss.completed)
        dismissVC()
    }
    
    func dismissVCWithRejection(){
        firstSurveyVC?.surveyOnDismiss?(CySurveyDismiss.rejected)
        dismissVC()
    }
    
    
    //MARK: Utils
    func removeStoredSurvey(){
        if let data = CyStorage.getCyDataModel(){
            data.last_surveys?.removeFirst()
            CyStorage.storeCyDataModel(cyData: data)
        }
    }
    
    func updateStoredSurvey(){
        if let data = CyStorage.getCyDataModel(){
            data.last_surveys?.removeFirst()
            if survey != nil{
                data.last_surveys?.insert(survey!, at: 0)
                CyStorage.storeCyDataModel(cyData: data)
            }
        }
    }
    
}
