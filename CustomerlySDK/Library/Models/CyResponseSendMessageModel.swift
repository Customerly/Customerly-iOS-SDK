//
//  CyResponseSendMessageModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import ObjectMapper

class CyResponseSendMessageModel: Mappable {

    var filename : String? //for example attachment.jpg
    var cookies : String? //file encoding base 64
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        filename <- map["filename"]
        base64 <- map["base64"]
    }
}
