//
//  CySurveyParamsRequestModel.swift
//  Customerly

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
