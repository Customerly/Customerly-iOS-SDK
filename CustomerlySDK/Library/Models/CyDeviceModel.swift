//
//  CyDeviceModel.swift
//  Customerly

import ObjectMapper

class CyDeviceModel: Mappable {

    var os : String = cy_os
    var app_name : String = cy_app_name
    var app_version : String = cy_app_version
    var app_build : String = cy_app_build
    var device : String = cy_device
    var os_version : String = cy_os_version
    var sdk_version : String = cy_sdk_version
    var api_version : String = cy_api_version
    var socket_version : String = cy_socket_version
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        os <- map["os"]
        app_name <- map["app_name"]
        app_version <- map["app_version"]
        app_build <- map["app_build"]
        device <- map["device"]
        os_version <- map["os_version"]
        sdk_version <- map["sdk_version"]
        api_version <- map["api_version"]
        socket_version <- map["socket_version"]
    }
    
}
