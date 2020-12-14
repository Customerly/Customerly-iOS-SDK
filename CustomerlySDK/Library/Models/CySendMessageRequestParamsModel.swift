//
//  CySendMessageRequestParamsModel.swift
//  Customerly

import ObjectMapper

class CySendMessageRequestParamsModel: Mappable {

    var conversation_id: Int?
    var message: String?
    var attachments: [CyMessageAttachmentRequestModel]? = []
    var lead_hash: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_id <- map["conversation_id"]
        message <- map["message"]
        attachments <- map["attachments"]
        lead_hash <- map["lead_hash"]
    }
    
}
