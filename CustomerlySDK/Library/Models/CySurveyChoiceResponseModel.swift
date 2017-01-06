//
//  CySurveyChoiceResponseModel.swift
//  Customerly
//
//  Created by Paolo Musolino on 04/01/17.
//  Copyright © 2017 Customerly. All rights reserved.
//

import ObjectMapper

class CySurveyChoiceResponseModel: Mappable {

    var value : String?
    var choice_id: Int?
    var survey_id: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        value <- map["value"]
        choice_id <- map["survey_choice_id"]
        survey_id <- map["survey_id"]
    }
}
