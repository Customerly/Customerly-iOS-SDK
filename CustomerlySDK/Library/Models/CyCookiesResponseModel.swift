//
//  CyCookiesResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/11/16.
//
//

import ObjectMapper

class CyCookiesResponseModel: Mappable {

    var customerly_user_token : String?
    var customerly_user_token_expire : Int?
    var customerly_lead_token : String?
    var customerly_lead_token_expire : Int?
    var customerly_temp_token : String?
    var customerly_temp_token_expire : Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        customerly_user_token <- map["customerly_user_token.value"]
        customerly_user_token_expire <- map["customerly_user_token.expire"]
        customerly_lead_token <- map["customerly_lead_token.value"]
        customerly_lead_token_expire <- map["customerly_lead_token.expire"]
        customerly_temp_token <- map["customerly_temp_token.value"]
        customerly_temp_token_expire <- map["customerly_temp_token.expire"]
    }
    
}
