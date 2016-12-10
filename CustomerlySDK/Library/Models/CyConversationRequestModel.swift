//
//  CyConversationRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyConversationRequestModel: Mappable {

    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    var params : CySendMessageRequestParamsModel? = CySendMessageRequestParamsModel(JSON: [:])
    var conversation_id : Int?
    var cookies : CyCookiesRequestModel? = CyCookiesRequestModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        settings <- map["settings"]
        params <- map["params"]
        conversation_id <- map["params.conversation_id"]
        cookies <- map["cookies"]
    }
    
}
