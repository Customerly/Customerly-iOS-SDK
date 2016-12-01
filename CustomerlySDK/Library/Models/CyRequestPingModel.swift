//
//  CyRequestPingModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/11/16.
//
//

import ObjectMapper

class CyRequestPingModel: Mappable {

    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    var params : [String:String]?
    var cookies : CyCookiesRequestModel? = CyCookiesRequestModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        settings <- map["settings"]
        params <- map["params"]
        cookies <- map["cookies"]
    }
}
