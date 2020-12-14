//
//  CySurveyResponseModel.swift
//  Customerly

import ObjectMapper

class CySurveyResponseModel: Mappable {

    var survey_id : Int?
    var seen_at: Int?
    var thankyou_text : String?
    var question_title: String?
    var question_subtitle: String?
    var question_type: Int?
    var limit_from: Int?
    var limit_to: Int?
    var step: Int?
    var choices: [CySurveyChoiceResponseModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        survey_id <- map["survey.survey_id"]
        seen_at <- map["seen_at"]
        thankyou_text <- map["survey.thankyou_text"]
        question_title <- map["question.title"]
        question_subtitle <- map["question.subtitle"]
        question_type <- map["question.type"]
        limit_from <- map["question.limit_from"]
        limit_to <- map["question.limit_to"]
        step <- map["question.step"]
        choices <- map["question.choices"]
    }
}
