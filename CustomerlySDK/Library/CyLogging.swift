//
//  CyLogging.swift
//  Customerly

class CyLogging: NSObject {
    
}


func cyPrint(_ items: Any...){
    if Customerly.sharedInstance.verboseLogging == true{
            print("CustomerlyLogging🤖:", items)
    }
}
