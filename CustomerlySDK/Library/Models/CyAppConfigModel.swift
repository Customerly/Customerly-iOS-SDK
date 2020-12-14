//
//  CyAppConfigModel.swift
//  Customerly

import ObjectMapper

class CyAppConfigModel: Mappable {

    var app_id: String?
    var widget_color: String?
    var widget_icon: Bool?
    var widget_position: Bool?
    var branded_widget: Bool?
    var default_screenshot: Bool?
    var user_audio_notification: Bool?
    var welcome_message_users: String?
    var welcome_message_visitors: String?
    var automatic_response: Bool?
    var automatic_response_users: String?
    var automatic_response_visitors: String?
    var trigger_email_after_inapp_notseen: Int?
    var widget_background_url: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        app_id <- map["app_id"]
        widget_color <- map["widget_color"]
        widget_icon <- map["widget_icon"]
        widget_position <- map["widget_position"]
        branded_widget <- map["branded_widget"]
        default_screenshot <- map["default_screenshot"]
        user_audio_notification <- map["user_audio_notification"]
        welcome_message_users <- map["welcome_message_users"]
        welcome_message_visitors <- map["welcome_message_visitors"]
        automatic_response <- map["automatic_response"]
        automatic_response_users <- map["automatic_response_users"]
        automatic_response_visitors <- map["automatic_response_visitors"]
        trigger_email_after_inapp_notseen <- map["trigger_email_after_inapp_notseen"]
        widget_background_url <- map["widget_background_url"]
    }
}
