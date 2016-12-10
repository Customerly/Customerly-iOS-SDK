//
//  CyConversationMessagesResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyConversationMessagesResponseModel: Mappable {

    var messages : [CyMessageModel]?
    var cookies : CyCookiesResponseModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        messages <- map["data.messages"]
        cookies <- map["cookies"]
    }
    
    
}
