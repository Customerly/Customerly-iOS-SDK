//
//  CySurveyChoiseResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import ObjectMapper

class CySurveyChoiseResponseModel: Mappable {

    var value : String?
    var choise_id: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        value <- map["value"]
        choise_id <- map["survey_choise_id"]
    }
}
