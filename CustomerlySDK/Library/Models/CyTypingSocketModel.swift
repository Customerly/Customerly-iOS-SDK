//
//  CyTypingSocketModel.swift
//  Customerly

import ObjectMapper

class CyTypingSocketModel: Mappable {
    
    var conversation_id : Int?
    var user_id : Int?
    var is_note: Bool? = false
    var is_typing: String?
    var typing_preview: String?
    var account_id: Int? //only socket on
    var account_name: String? //only socket on
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_id <- map["conversation.conversation_id"]
        user_id <- map["conversation.user_id"]
        is_note <- map["conversation.is_note"]
        is_typing <- map["is_typing"]
        typing_preview <- map["typing_preview"]
        account_id <- map["client.account_id"]
        account_name <- map["client.name"]
    }
}
