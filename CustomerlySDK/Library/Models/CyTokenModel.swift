//
//  CyTokenModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 14/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

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
