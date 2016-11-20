//
//  CyStorageModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 11/11/16.
//
//

import ObjectMapper

class CyStorageModel: Mappable {
    
    //User
    var app_id : String?
    var user_id : String?
    var email : String?
    var name : String?
    var is_user : Bool?
    
    //Cookies
    var customerly_user_token : String?
    var customerly_lead_token : String?
    var customerly_temp_token : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        //User
        app_id <- map["app_id"]
        user_id <- map["user_id"]
        email <- map["email"]
        name <- map["name"]
        is_user <- map["is_user"]
        
        //Cookies
        customerly_user_token <- map["customerly_user_token"]
        customerly_lead_token <- map["customerly_lead_token"]
        customerly_temp_token <- map["customerly_temp_token"]
    }
}
