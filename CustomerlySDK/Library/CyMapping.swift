
//
//  CyMapping.swift
//  Customerly
//
//  Created by Paolo Musolino on 14/10/16.
//
//

import Foundation
//MARK: - CyMapping Utils

//Parse Dictionary from JSON Data
func JSONParseDictionary(data: Data?) -> [String:AnyObject]{
    
    if data != nil{
        do{
            if let dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]{
                return dictionary
            }
        }
        catch{
            cyPrint("Error! Could not create Dictionary from JSON Data.")
        }
    }
    
    return [String: AnyObject]()
}

//Parse Array from JSON Data
func JSONParseArray(data: Data?) -> [AnyObject]{
    
    if data != nil{
        do{
            
            if let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject] {
                return array
            }
        }catch{
            cyPrint("Error! Could not create Array from JSON Data.")
        }
    }
    
    return [AnyObject]()
}
