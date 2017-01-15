//
//  CyMessageSeenRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 27/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyMessageSeenRequestModel: Mappable {
    
    var token: String?
    var conversation_message_id: Int?
    var seen_date: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        conversation_message_id <- map["params.conversation_message_id"]
        seen_date <- map["params.seen_date"]
    }
    
}
