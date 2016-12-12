//
//  CyTypingSocketModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 12/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyTypingSocketModel: Mappable {
    
    var conversation_id : Int?
    var user_id : Int?
    var is_note: Bool? = false
    var is_typing: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_id <- map["conversation.conversation_id"]
        user_id <- map["conversation.user_id"]
        is_note <- map["conversation.is_note"]
        is_typing <- map["is_typing"]
    }
}
