//
//  CyTrackingRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 06/11/16.
//
//

import ObjectMapper

class CyTrackingRequestModel: Mappable {

    var token : String?
    var nameTracking : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        nameTracking <- map["params.name"]
    }
}
