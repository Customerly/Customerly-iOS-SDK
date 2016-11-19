//
//  CyCookiesResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/11/16.
//
//

import ObjectMapper

class CyCookiesResponseModel: Mappable {

    var crmCy_user_token : String?
    var crmCy_user_token_expire : Int?
    var crmCy_lead_token : String?
    var crmCy_lead_token_expire : Int?
    var crmCy_temp_token : String?
    var crmCy_temp_token_expire : Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        crmCy_user_token <- map["crmCy_user_token.value"]
        crmCy_user_token_expire <- map["crmCy_user_token.expire"]
        crmCy_lead_token <- map["crmCy_lead_token.value"]
        crmCy_lead_token_expire <- map["crmCy_lead_token.expire"]
        crmCy_temp_token <- map["crmCy_temp_token.value"]
        crmCy_temp_token_expire <- map["crmCy_temp_token.expire"]
    }
    
}
