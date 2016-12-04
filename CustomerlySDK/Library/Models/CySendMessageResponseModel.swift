//
//  CyResponseSendMessageModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CySendMessageResponseModel: Mappable {

    var user : CyUserModel?
    var conversation : CyConversationModel?
    var message: CyMessageModel?
    var timestamp : Int?
    var cookies : CyCookiesResponseModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        user <- map["data.user.data"]
        conversation <- map["data.conversation"]
        message <- map["data.message"]
        timestamp <- map["data.timestamp"]
        cookies <- map["cookies"]
    }
}
