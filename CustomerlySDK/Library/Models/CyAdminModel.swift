//
//  CyAdminModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 27/11/16.
//
//

import ObjectMapper

class CyAdminModel: Mappable {
    var account_id : Int?
    var email : String?
    var name : String?
    var last_active : Double?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        account_id <- map["account_id"]
        email <- map["email"]
        name <- map["name"]
        last_active <- map["last_active"]
    }
}
