//
//  CyMessageSeenRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 27/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyMessageSeenRequestModel: Mappable {
    
    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    //var params : CySendMessageRequestParamsModel? = CySendMessageRequestParamsModel(JSON: [:])
    var conversation_message_id: Int?
    var seen_date: Int?
    var cookies : CyCookiesRequestModel? = CyCookiesRequestModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        settings <- map["settings"]
        conversation_message_id <- map["params.conversation_message_id"]
        seen_date <- map["params.seen_date"]
        cookies <- map["cookies"]
    }
    
}
