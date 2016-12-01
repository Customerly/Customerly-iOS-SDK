//
//  CySendMessageRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 29/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CySendMessageRequestModel: Mappable {
    
    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    var params : CySendMessageRequestParamsModel? = CySendMessageRequestParamsModel(JSON: [:])
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
