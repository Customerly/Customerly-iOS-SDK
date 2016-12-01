//
//  CyCookiesRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyCookiesRequestModel: Mappable {

    var customerly_user_token : String?
    var customerly_lead_token : String?
    var customerly_temp_token : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        customerly_user_token <- map["customerly_user_token"]
        customerly_lead_token <- map["customerly_lead_token"]
        customerly_temp_token <- map["customerly_temp_token"]
    }
    
}
