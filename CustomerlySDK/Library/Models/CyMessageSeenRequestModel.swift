//
//  CyMessageSeenRequestModel.swift
//  Customerly

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
