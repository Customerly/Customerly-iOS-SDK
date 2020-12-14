//
//  CyConversationRetrieveResponseModel.swift
//  Customerly

import ObjectMapper

class CyConversationRetrieveResponseModel: Mappable {

    var conversations : [CyConversationModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversations <- map["conversations"]
    }
    
}
