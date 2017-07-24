//
//  CyErrorModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 24/07/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import ObjectMapper

class CyErrorModel: Mappable {

    var error_code: Int? //Error subcode
    var message: String? //es. - Subscription is expired, please contact Customerly.io;
    var status_code: Int? //http status code
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        error_code <- map["error.code"]
        message <- map["error.message"]
        status_code <- map["error.status_code"]
    }
    
}
