//
//  CyMessageAttachmentRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 29/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

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
