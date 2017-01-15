//
//  CyConversationRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

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
