//
//  CyRequestPingModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/11/16.
//
//

import ObjectMapper

class CyRequestPingModel: Mappable {

    var token: String?
    var params: CySettingsModel? = CySettingsModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        params <- map["params"]
    }
}
