//
//  CyTrackingModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyTrackingModel: Mappable {

    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    var nameTracking : String?
    var cookies : CyCookiesRequestModel? = CyCookiesRequestModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        settings <- map["settings"]
        nameTracking <- map["params.name"]
        cookies <- map["cookies"]
    }
}
