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
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        messages <- map["messages"]
    }
    
}
