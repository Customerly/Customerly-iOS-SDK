//
//  CyRequestPingModel.swift
//  Customerly

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
