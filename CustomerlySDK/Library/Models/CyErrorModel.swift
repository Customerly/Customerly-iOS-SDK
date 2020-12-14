//
//  CyErrorModel.swift
//  Customerly

import ObjectMapper

class CyErrorModel: Mappable {

    var error_code: Int? //Error subcode
    var message: String? //es. - Subscription is expired, please contact Customerly.io;
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        error_code <- map["code"]
        message <- map["message"]
    }
    
}
