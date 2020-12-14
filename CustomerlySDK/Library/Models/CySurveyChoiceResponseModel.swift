//
//  CySurveyChoiceResponseModel.swift
//  Customerly

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
