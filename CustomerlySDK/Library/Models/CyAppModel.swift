//
//  CyAppModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/11/16.
//
//

import ObjectMapper

class CyAppModel: Mappable {

    var app_id : String?
    var name : String?
    var secure_mode : Int?
    var time_zone : String?
    var redundancy_notifications : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        app_id <- map["app_id"]
        name <- map["name"]
        secure_mode <- map["secure_mode"]
        time_zone <- map["time_zone"]
        redundancy_notifications <- map["redundancy_notifications"]
    }
}
