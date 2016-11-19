//
//  CyLogging.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

class CyLogging: NSObject {
    
}


func cyPrint(_ items: Any...){
    if Customerly.sharedInstance.verboseLogging == true{
        if let stringToPrint = (items as? [String])?.joined(separator: " "){
            print("CustomerlyLogging🤖:", stringToPrint)
        }
    }
}
