//
//  CySendMessageResponseModel.swift
//  Customerly

import ObjectMapper

class CySendMessageResponseModel: Mappable {

    var token: String?
    var user: CyUserModel?
    var conversation: CyConversationModel?
    var message: CyMessageModel?
    var timestamp: Int?
    var lead_hash: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        user <- map["user.data"]
        conversation <- map["conversation"]
        message <- map["message"]
        timestamp <- map["timestamp"]
        lead_hash <- map["lead_hash"]
    }
}
