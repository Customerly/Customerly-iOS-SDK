//
//  CyMessageSocketModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 12/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

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
