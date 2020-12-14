//
//  CyWebsocketModel.swift
//  Customerly


import ObjectMapper

class CyWebsocketModel: Mappable {

    var endpoint: String?
    var port: String?
    var token: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        endpoint <- map["endpoint"]
        port <- map["port"]
        token <- map["token"]
    }
}
