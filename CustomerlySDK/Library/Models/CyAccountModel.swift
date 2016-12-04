//
//  CyAccountModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyAccountModel: Mappable {
    
    var account_id : Int?
    var name : String?
    var email: String?
    var last_active : Int?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        account_id <- map["account_id"]
        name <- map["name"]
        email <- map["email"]
        last_active <- map["last_active"]
    }
    
}
