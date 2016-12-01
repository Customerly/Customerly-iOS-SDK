//
//  CyAttachmentModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 01/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

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
