//
//  CyRequestSendMessageModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 29/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyRequestSendMessageModel: Mappable {
    
    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    var params : CyRequestSendMessageParamsModel? = CyRequestSendMessageParamsModel(JSON: [:])
    var cookies : CyCookiesModel? = CyCookiesModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        settings <- map["settings"]
        params <- map["params"]
        cookies <- map["cookies"]
    }
}
