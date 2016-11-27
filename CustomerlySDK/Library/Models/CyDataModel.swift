//
//  CyDataModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyDataModel: Mappable {

    var websocket : CyWebsocketModel?
    var app : CyAppModel?
    var app_config : CyAppConfigModel?
    var active_admins : [CyAdminModel]?
    var user : CyUserModel?
    //var last_messages : String? //TODO: structure
    //var last_surveys : String? //TODO: structure
    var cookies : CyCookiesResponseModel?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        websocket <- map["data.websocket"]
        app <- map["data.apps.app"]
        app_config <- map["data.apps.app_config"]
        active_admins <- map["data.active_admins"]
        user <- map["data.user.data"]
        cookies <- map["cookies"]
    }
    
    
}
