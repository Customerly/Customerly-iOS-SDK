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
            print("CustomerlyLogging🤖:", items)
    }
}
