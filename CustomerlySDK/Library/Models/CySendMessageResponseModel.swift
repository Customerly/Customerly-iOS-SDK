//
//  CySendMessageResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CySendMessageResponseModel: Mappable {

    var token: String?
    var user: CyUserModel?
    var conversation: CyConversationModel?
    var message: CyMessageModel?
    var timestamp: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        user <- map["user.data"]
        conversation <- map["conversation"]
        message <- map["message"]
        timestamp <- map["timestamp"]
    }
}
