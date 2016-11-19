//
//  CyWebsocketModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/11/16.
//
//

import ObjectMapper

class CyWebsocketModel: Mappable {

    var endpoint : String?
    var port : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        endpoint <- map["endpoint"]
        port <- map["port"]
    }
}
