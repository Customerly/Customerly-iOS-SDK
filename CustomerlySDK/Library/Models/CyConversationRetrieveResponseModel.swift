//
//  CyConversationRetrieveResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

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
