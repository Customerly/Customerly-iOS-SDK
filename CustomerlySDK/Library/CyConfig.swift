//
//  CyConfig.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//

import Foundation

let API_BASE_URL = "https://tracking.customerly.io" + API_VERSION
let API_VERSION = "/v" + cy_api_version
let CUSTOMERLY_URL = "https://www.customerly.io"

// The domain used for creating all Customerly errors.
let cy_domain = "io.customerly.CustomerlySDK"

// Extra device and app info
let cy_app_version = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")"
let cy_app_build : String = Bundle.main.object(forInfoDictionaryKey:kCFBundleVersionKey as String) as! String
let cy_device = UIDevice.current.model
let cy_os = UIDevice.current.systemName
let cy_os_version = UIDevice.current.systemVersion
let cy_app_name : String = Bundle.main.object(forInfoDictionaryKey:kCFBundleNameKey as String) as! String
let cy_sdk_version = "1"
let cy_api_version = "1"
let cy_socket_version = "1"
let cy_preferred_language = NSLocale.preferredLanguages.count > 0 ? NSLocale.preferredLanguages[0] : nil

//Default parameters
let base_color_template = UIColor(hexString: "#1fb1fc")
var user_color_template: UIColor?

//Images
func adminImageURL(id: Int?, pxSize: Int) -> URL{
    if let admin_id = id{
        return URL(string: "https://pictures.cdn.customerly.io/accounts/\(admin_id)/\(pxSize)")!
    }
    return URL(string: "https://pictures.cdn.customerly.io/accounts/-/\(pxSize)")!
    }

func userImageURL(id: Int?, pxSize: Int) -> URL{
    if let user_id = id{
        return URL(string: "https://pictures.cdn.customerly.io/users/\(user_id)/\(pxSize)")!
    }
    return URL(string: "https://pictures.cdn.customerly.io/users/-/\(pxSize)")!
}

enum CyUserType: Int {
    case anonymous = 1
    case lead = 2
    case user = 4
}
