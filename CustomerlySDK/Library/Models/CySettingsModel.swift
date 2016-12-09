//
//  CySettingsModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CySettingsModel: Mappable {

    var app_id : String = Customerly.sharedInstance.customerlySecretKey
    var user_id : String?
    var email : String?
    var name : String?
    var device : CyDeviceModel? = CyDeviceModel(JSON: [:])
    var attributes : Dictionary<String, AnyObject?>?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        app_id <- map["app_id"]
        user_id <- map["user_id"]
        email <- map["email"]
        name <- map["name"]
        device <- map["device"]
        attributes <- map["attributes"]
    }
    
}
