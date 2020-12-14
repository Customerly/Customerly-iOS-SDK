//
//  CySendMessageRequestModel.swift
//  Customerly

import ObjectMapper

class CySendMessageRequestModel: Mappable {
    
    var token: String?
    var params: CySendMessageRequestParamsModel? = CySendMessageRequestParamsModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        params <- map["params"]
    }
    
}
