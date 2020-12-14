//
//  CyConversationRequestModel.swift
//  Customerly

import ObjectMapper

class CyConversationRequestModel: Mappable {

    var token: String?
    var params: CySendMessageRequestParamsModel? = CySendMessageRequestParamsModel(JSON: [:])
    var timestamp: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        params <- map["params"]
        timestamp <- map ["params.timestamp"]
    }
    
}
