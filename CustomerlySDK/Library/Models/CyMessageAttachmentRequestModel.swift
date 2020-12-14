//
//  CyMessageAttachmentRequestModel.swift
//  Customerly

import ObjectMapper

class CyMessageAttachmentRequestModel: Mappable {

    var filename : String? //for example attachment.jpg
    var base64 : String? //file encoding base 64
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        filename <- map["filename"]
        base64 <- map["base64"]
    }
}
