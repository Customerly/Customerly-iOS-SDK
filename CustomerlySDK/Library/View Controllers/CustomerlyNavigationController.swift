//
//  CustomerlyNavigationController.swift
//  Customerly

import UIKit

class CustomerlyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        applyNavBarCustomization()
        applySwipeGesture()
        
        // Always adopt a light interface style.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Customizations
    func applyNavBarCustomization(){
        
        self.navigationBar.barTintColor = base_color_template //background color navbar
        self.navigationBar.tintColor = UIColor.white //tint color elements on navbar
        self.navigationBar.isTranslucent = false //navbar is not translucent
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //font title navbar
        
        //Delete 1px line under navigation bar
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        if let app_config = CyStorage.getCyDataModel()?.app_config{
            self.navigationBar.barTintColor = app_config.widget_color != nil ? UIColor(hexString: app_config.widget_color!) : base_color_template
        }
        
        if user_color_template != nil{
            self.navigationBar.barTintColor = user_color_template
        }
        
        self.navigationBar.backgroundColor = self.navigationBar.barTintColor
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
