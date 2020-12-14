//
//  CyBundle.swift
//  Customerly

import UIKit

class CyBundle: Bundle {

    static func getBundle() -> Bundle{
        let podBundle = Bundle(for: Customerly.classForCoder())
        if let bundleURL = podBundle.url(forResource: "CustomerlySDK", withExtension: "bundle"){
            if let bundle = Bundle(url: bundleURL) {
                return bundle
            }
        }
        
            return Bundle(for: Customerly.classForCoder())
    }
}
