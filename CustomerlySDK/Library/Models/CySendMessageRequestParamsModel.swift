//
//  CySendMessageRequestParamsModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 29/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CySendMessageRequestParamsModel: Mappable {

    var conversation_id: String?
    var message: String?
    var attachments: [CyMessageAttachmentRequestModel]? = []
    var visitor_email: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        conversation_id <- map["conversation_id"]
        message <- map["message"]
        attachments <- map["attachments"]
        visitor_email <- map["visitor_email"]
    }
    
}
