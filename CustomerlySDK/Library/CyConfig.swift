//
//  CyConfig.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//

let API_BASE_URL = "http://tracking.customerly.io"

// The domain used for creating all Customerly errors.
let cy_domain = "io.customerly.CustomerlySDK"

// Extra device and app info
let cy_app_version = "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")" //TODO: App end developer
let cy_app_build = Bundle.main.object(forInfoDictionaryKey:kCFBundleVersionKey as String) //TODO: App end developer
let cy_device = UIDevice.current.model
let cy_os = UIDevice.current.systemName
let cy_os_version = UIDevice.current.systemVersion
let cy_app_name = "Customerly iOS SDK" //TODO: App end developer
let cy_sdk_version = "\(1)"
let cy_api_version = "\(1)"
let cy_socket_version = "\(1)"
