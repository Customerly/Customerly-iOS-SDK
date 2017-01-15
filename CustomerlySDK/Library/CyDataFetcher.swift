//
//  CyDataFetcher.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//

import ObjectMapper

class CyDataFetcher: NSObject {
    
    var session : URLSession? //Session manager
    
    //MARK: Singleton
    static let sharedInstance = CyDataFetcher(managerCachePolicy: .reloadIgnoringLocalCacheData)
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    init(managerCachePolicy:NSURLRequest.CachePolicy){
        super.init()
        self.configure(cachePolicy: managerCachePolicy)
    }
    
    //MARK: Session Configuration
    func configure(cachePolicy:NSURLRequest.CachePolicy?){
        let sessionConfiguration = URLSessionConfiguration.default //URLSessionConfiguration()
        sessionConfiguration.timeoutIntervalForRequest = 15.0
        sessionConfiguration.requestCachePolicy = cachePolicy != nil ? cachePolicy! : .reloadIgnoringLocalCacheData
        sessionConfiguration.httpAdditionalHeaders = ["Accept-Language": cy_preferred_language ?? "en"]
        
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    
    //MARK: API Track
    func trackEventAPIRequest(trackingRequest: CyTrackingRequestModel?, completion: @escaping () -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.Event(trackingRequest?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        
        task?.resume()
    }
    
    //MARK: API Ping
    func pingAPIRequest(pingModel:CyRequestPingModel?, completion: @escaping (CyDataModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.Ping(pingModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let ping = Mapper<CyDataModel>().map(JSON: JSONParseDictionary(data: data))
                completion(ping)
            }
        }
        
        task?.resume()
    }
    
    //MARK: API Chat
    
    //Send a message
    func sendMessage(messageModel:CySendMessageRequestModel?, completion: @escaping (CySendMessageResponseModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.MessageSend(messageModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let messageDataResponse = Mapper<CySendMessageResponseModel>().map(JSON: JSONParseDictionary(data: data))
                completion(messageDataResponse)
            }
        }
        
        task?.resume()
    }
    
    //Download all conversations
    func retriveConversations(conversationRequestModel:CyConversationRequestModel?, completion: @escaping (CyConversationRetrieveResponseModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.ConversationRetrieve(conversationRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let conversations = Mapper<CyConversationRetrieveResponseModel>().map(JSON: JSONParseDictionary(data: data))
                completion(conversations)
            }
        }
        
        task?.resume()
    }
    
    //Download all messages in a conversation
    func retrieveConversationMessages(conversationMessagesRequestModel:CyConversationRequestModel?, completion: @escaping (CyConversationMessagesResponseModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.ConversationMessagesRetrieve(conversationMessagesRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let conversationMessages = Mapper<CyConversationMessagesResponseModel>().map(JSON: JSONParseDictionary(data: data))
                completion(conversationMessages)
            }
        }
        
        task?.resume()
    }
    
    //Download all messages in a conversation after a timestamp
    func retrieveConversationMessagesNews(conversationMessagesRequestModel:CyConversationRequestModel?, completion: @escaping (CyConversationMessagesResponseModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.ConversationMessagesRetrieveNews(conversationMessagesRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let conversationMessages = Mapper<CyConversationMessagesResponseModel>().map(JSON: JSONParseDictionary(data: data))
                completion(conversationMessages)
            }
        }
        
        task?.resume()
    }
    
    //Admin message seen from user
    func messageSeen(messageSeenRequestModel:CyMessageSeenRequestModel?, completion: @escaping () -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.MessageSeen(messageSeenRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        
        task?.resume()
    }
    
    //MARK: API Survey
    func submitSurvey(surveyRequestModel:CySurveyParamsRequestModel?, completion: @escaping (CySurveyResponseModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.SurveySubmit(surveyRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let surveyResponse = Mapper<CySurveyResponseModel>().map(JSON: JSONParseDictionary(data: data))
                completion(surveyResponse)
            }
        }
        
        task?.resume()
    }
    
    func surveyBack(surveyRequestModel:CySurveyParamsRequestModel?, completion: @escaping (CySurveyResponseModel?) -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.SurveyBack(surveyRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                let surveyResponse = Mapper<CySurveyResponseModel>().map(JSON: JSONParseDictionary(data: data))
                completion(surveyResponse)
            }
        }
        
        task?.resume()
    }
    
    func surveySeen(surveyRequestModel:CySurveyParamsRequestModel?, completion: @escaping () -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.SurveySeen(surveyRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        
        task?.resume()
    }
    
    func surveyReject(surveyRequestModel:CySurveyParamsRequestModel?, completion: @escaping () -> Void, failure:@escaping (Error) -> Void){
        var urlRequest = CyRouting.SurveyReject(surveyRequestModel?.toJSON()).urlRequest
        urlRequest.httpMethod = "POST"
        
        let task = session?.dataTask(with: urlRequest) {
            (
            data, response, error) in
            
            guard response?.validate() == nil else{
                failure(response!.validate()!)
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        
        task?.resume()
    }
    
}


