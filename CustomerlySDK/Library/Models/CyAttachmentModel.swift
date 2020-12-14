//
//  CyAttachmentModel.swift
//  Customerly

import ObjectMapper

class CyAttachmentModel: Mappable {

    var size : Int?
    var path : String?
    var name: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        size <- map["size"]
        path <- map["path"]
        name <- map["name"]
    }
    
}
