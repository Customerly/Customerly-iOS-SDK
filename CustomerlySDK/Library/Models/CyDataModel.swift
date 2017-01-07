//
//  CyDataModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyDataModel: Mappable {

    var websocket: CyWebsocketModel?
    var app: CyAppModel?
    var app_config: CyAppConfigModel?
    var active_admins: [CyAdminModel]?
    var user: CyUserModel?
    var last_messages: [CyMessageModel]?
    var last_surveys : [CySurveyResponseModel]?
    var cookies: CyCookiesResponseModel?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        websocket <- map["data.websocket"]
        app <- map["data.apps.app"]
        app_config <- map["data.apps.app_config"]
        active_admins <- map["data.active_admins"]
        user <- map["data.user.data"]
        last_messages <- map["data.last_messages"]
        last_surveys <- map["data.last_surveys"]
        cookies <- map["cookies"]
    }
    
    
}
