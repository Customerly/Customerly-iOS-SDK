//
//  CySendMessageRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 29/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CySendMessageRequestModel: Mappable {
    
    var token: String?
    var params : CySendMessageRequestParamsModel? = CySendMessageRequestParamsModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        params <- map["params"]
    }
    
}
