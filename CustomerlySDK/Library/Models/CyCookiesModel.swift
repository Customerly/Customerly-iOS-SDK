//
//  CyCookiesModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyCookiesModel: Mappable {

    var crmCy_user_token : String?
    var crmCy_lead_token : String?
    var crmCy_temp_token : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        crmCy_user_token <- map["crmCy_user_token"]
        crmCy_lead_token <- map["crmCy_lead_token"]
        crmCy_temp_token <- map["crmCy_temp_token"]
    }
    
}
