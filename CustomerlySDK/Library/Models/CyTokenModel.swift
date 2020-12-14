//
//  CyTokenModel.swift
//  Customerly

import ObjectMapper

class CyTokenModel: Mappable {
    
    var user_type: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        user_type <- map["type"]
    }
    
}
