//
//  CyDataFetcher.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//

import ObjectMapper

open class CyDataFetcher: NSObject {
    
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
        
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    
    //MARK: API Track
    func trackEventAPIRequest(eventName:String, completion: @escaping () -> Void, failure:@escaping (Error) -> Void){
        let trackingModel = CyTrackingModel(JSON: [:])
        trackingModel?.nameTracking = eventName
        trackingModel?.settings?.email = "firstEventFromSDK@gmail.com"
        trackingModel?.settings?.name = "Paolo Musolino"
        trackingModel?.settings?.user_id = "ABC123"
        trackingModel?.cookies?.customerly_user_token = "76601427f054d4822436ee69061e166eef7d5c5c4b6f9f50eda026a751667c74-214454"
        var urlRequest = CyRouting.Event(trackingModel?.toJSON()).urlRequest
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
                let ping = Mapper<CyDataModel>().map(JSON: JSONParseDictionary(data: data!))
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
                let messageDataResponse = Mapper<CySendMessageResponseModel>().map(JSON: JSONParseDictionary(data: data!))
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
                let conversations = Mapper<CyConversationRetrieveResponseModel>().map(JSON: JSONParseDictionary(data: data!))
                completion(conversations)
            }
        }
        
        task?.resume()
    }
}
