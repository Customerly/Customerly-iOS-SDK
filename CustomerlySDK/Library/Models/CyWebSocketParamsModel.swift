//
//  CyWebSocketParamsModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 13/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyWebSocketParamsModel: Mappable {

    var app: String?
    var crmhero_user_id: Int?
    var nsp: String = "user"
    var is_mobile: Bool = true
    
    required init?(map: Map) {
    }

    func mapping(map: Map)
    {
        app <- map["app"]
        crmhero_user_id <- map["id"]
        nsp <- map["nsp"]
        is_mobile <- map["is_mobile"]
    }
}
