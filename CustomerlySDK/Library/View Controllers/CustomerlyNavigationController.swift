//
//  CustomerlyNavigationController.swift
//  Customerly
//
//  Created by Paolo Musolino on 19/11/16.
//
//

import UIKit

class CustomerlyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        applyNavBarCustomization()
        applySwipeGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //The chat flow support only portrait orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return UIInterfaceOrientationMask.portrait
    }

    //MARK: Customizations
    func applyNavBarCustomization(){
        
        self.navigationBar.barTintColor = base_color_template //background color navbar
        self.navigationBar.tintColor = UIColor.white //tint color elements on navbar
        self.navigationBar.isTranslucent = false //navbar is not translucent
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white] //font title navbar
        
        //Delete 1px line under navigation bar
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        if let app_config = CyStorage.getCyDataModel()?.app_config{
            self.navigationBar.barTintColor = app_config.widget_color != nil ? UIColor(hexString: app_config.widget_color!) : base_color_template
        }
        
        if user_color_template != nil{
            self.navigationBar.barTintColor = user_color_template
        }
        
    }
    
    //enable "swipe left to right" gesture to navigate to the previous controller when the back button is custom
    func applySwipeGesture(){
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)){
            self.interactivePopGestureRecognizer?.isEnabled = true
            self.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
}

extension CustomerlyNavigationController: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
