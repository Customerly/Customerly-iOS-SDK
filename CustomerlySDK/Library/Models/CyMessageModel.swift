//
//  CyMessageModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyMessageModel: Mappable {

    var conversation_message_id : Int?
    var conversation_id : Int?
    var user_id: Int?
    var account_id: Int?
    var content: String?
    var sent_date: Int?
    var seen_date: Int?
    var type: Int?
    var close_conversation: Int?
    var attachments: [CyAttachmentModel]?
    var account: CyAccountModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_message_id <- map["conversation_message_id"]
        conversation_id <- map["conversation_id"]
        user_id <- map["user_id"]
        account_id <- map["account_id"]
        content <- map["content"]
        sent_date <- map["sent_date"]
        seen_date <- map["seen_date"]
        type <- map["type"]
        attachments <- map["attachments"]
        account <- map["account"]
    }
    
}
