//
//  CySeenMessageSocketModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 12/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CySeenMessageSocketModel: Mappable {

    var seen_date : Int?
    var conversation_message_id : Int?
    var user_id: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        seen_date <- map["seen_date"]
        conversation_message_id <- map["conversation.conversation_message_id"]
        user_id <- map["conversation.user_id"]
    }
    
}
