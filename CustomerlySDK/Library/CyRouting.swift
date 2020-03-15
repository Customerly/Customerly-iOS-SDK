//
//  CyRouting.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//


enum CyRouting{

    case Ping([String: Any]?)
    case Event([String: Any]?)
    case MessageSend([String: Any]?)
    case ConversationRetrieve([String: Any]?)
    case ConversationMessagesRetrieve([String: Any]?)
    case ConversationMessagesRetrieveNews([String: Any]?)
    case MessageSeen([String: Any]?)
    case SurveySubmit([String: Any]?)
    case SurveyBack([String: Any]?)
    case SurveySeen([String: Any]?)
    case SurveyReject([String: Any]?)
    
    var urlRequest: URLRequest{
        let touple : (path: String, parameters: [String: Any]?) = {
            switch self{
            
            case .Ping(let params):
                return("/ping/index/", params)
                
            case .Event(let params):
                return("/event/", params)
                
            case .MessageSend(let params):
                return("/message/send/", params)
                
            case .ConversationRetrieve(let params):
                return("/conversation/retrieve/", params)
                
            case .ConversationMessagesRetrieve(let params):
                return("/message/retrieve/", params)
                
            case .ConversationMessagesRetrieveNews(let params):
                return("/message/news/", params)
                
            case .MessageSeen(let params):
                return("/message/seen/", params)
                
            case .SurveySubmit(let params):
                return("/survey/submit/", params)
                
            case .SurveyBack(let params):
                return("/survey/back/", params)
                
            case .SurveySeen(let params):
                return("/survey/seen/", params)
                
            case .SurveyReject(let params):
                return("/survey/reject/", params)
                
            }
        }()
        
        let url:URL = URL(string: API_BASE_URL)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(touple.path))
        urlRequest.httpBody = CyRouting.createDataFromJSONDictionary(dataToSend: touple.parameters)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("ios", forHTTPHeaderField: "Customerly-sdk")
        urlRequest.addValue(cy_sdk_version, forHTTPHeaderField: "Customerly-sdk-version")

        return urlRequest
    }
    
    
    static func createDataFromJSONDictionary(dataToSend: [String:Any]?) -> Data?{
        
        guard dataToSend != nil else{
            return nil
        }
        do{
            if JSONSerialization.isValidJSONObject(dataToSend! as NSDictionary){
                
                let json = try JSONSerialization.data(withJSONObject: dataToSend! as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let data_string = String(data: json, encoding: String.Encoding.utf8)
                
                return data_string?.data(using: String.Encoding.utf8)
            }
        }
        catch{
            cyPrint("Error! Could not create JSON for server payload.")
            return nil
        }
        
        return nil
    }
}


