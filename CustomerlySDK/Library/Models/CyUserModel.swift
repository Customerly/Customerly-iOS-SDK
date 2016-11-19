//
//  CyUserModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyUserModel: Mappable {
    
    var app_id : String?
    var user_id : String?
    var email : String?
    var name : String?
    var is_user : Bool?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        app_id <- map["app_id"]
        user_id <- map["user_id"]
        email <- map["email"]
        name <- map["name"]
        is_user <- map["is_user"]
    }
}
