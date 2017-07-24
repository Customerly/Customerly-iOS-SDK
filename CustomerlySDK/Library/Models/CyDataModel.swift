//
//  CyDataModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyDataModel: Mappable {

    var token: String?
    var min_version_ios: String?
    var websocket: CyWebsocketModel?
    var app: CyAppModel?
    var app_config: CyAppConfigModel?
    var active_admins: [CyAdminModel]?
    var user: CyUserModel?
    var last_messages: [CyMessageModel]?
    var last_surveys : [CySurveyResponseModel]?
    var insolvent: Bool = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        min_version_ios <- map["min-version-ios"]
        websocket <- map["websocket"]
        app <- map["app"]
        app_config <- map["app_config"]
        active_admins <- map["active_admins"]
        user <- map["user.data"]
        last_messages <- map["last_messages"]
        last_surveys <- map["last_surveys"]
        insolvent <- map["insolvent"]
    }
    
}
