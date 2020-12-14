//
//  CyMessageSocketModel.swift
//  Customerly

import ObjectMapper

class CyMessageSocketModel: Mappable {

    var timestamp : Int?
    var user_id : Int?
    var is_note: Bool? = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        timestamp <- map["timestamp"]
        user_id <- map["user_id"]
        is_note <- map["conversation.is_note"]
    }
    
}
