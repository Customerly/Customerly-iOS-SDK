//
//  CySurveyParamsRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import ObjectMapper

class CySurveyParamsRequestModel: Mappable {

    var settings : CySettingsModel? = CySettingsModel(JSON: [:])
    var survey_id : Int?
    var choice_id: Int?
    var answer: String?
    var cookies : CyCookiesRequestModel? = CyCookiesRequestModel(JSON: [:])
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        settings <- map["settings"]
        survey_id <- map["params.survey_id"]
        choice_id <- map["params.choice_id"]
        answer <- map["params.answer"]
        cookies <- map["cookies"]
    }
}
