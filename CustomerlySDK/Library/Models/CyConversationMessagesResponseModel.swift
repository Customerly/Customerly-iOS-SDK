//
//  CyConversationMessagesResponseModel.swift
//  Customerly

import ObjectMapper

class CyConversationMessagesResponseModel: Mappable {

    var messages : [CyMessageModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        messages <- map["messages"]
    }
    
}
