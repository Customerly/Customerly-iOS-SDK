//
//  CyConversationModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyConversationModel: Mappable {

    var conversation_id : String?
    var user_id : String?
    var last_message_date: String?
    var last_message_abstract : String?
    var last_account: CyAccountModel?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_id <- map["conversation_id"]
        user_id <- map["user_id"]
        last_message_date <- map["last_message_date"]
        last_message_abstract <- map["last_message_abstract"]
        last_account <- map["last_account"]
    }
    
}
