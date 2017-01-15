//
//  CySurveyParamsRequestModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import ObjectMapper

class CySurveyParamsRequestModel: Mappable {

    var token : String?
    var survey_id : Int?
    var choice_id: Int?
    var answer: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        token <- map["token"]
        survey_id <- map["params.survey_id"]
        choice_id <- map["params.choice_id"]
        answer <- map["params.answer"]
    }
}
