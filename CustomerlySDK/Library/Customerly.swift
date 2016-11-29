//
//  Customerly.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/10/16.
//
//

open class Customerly: NSObject {

    open static let sharedInstance = Customerly()
    var customerlySecretKey : String = ""
    
    /*
     * Enable verbose logging, that is useful for debugging. By default is enabled.
     */
    open var verboseLogging : Bool = true
    
    //MARK: Init
    override init() {
        super.init()
    }
    
    
    
    //MARK: - OPEN APIs
    
    //MARK: Configuration
    open func configure(secretKey: String){
        customerlySecretKey = secretKey
        
        //If user is not stored, ping ghost, else ping registered
            ping()
    }
    
    open func setUser(){
        
    }
    
    //MARK: Event
    /*
     * Track an event. The event string myst be alphanumeric, eventually with _ separator.
     * Valid string example: "tap_subscription_page"
     * Not valid string: "tap subscription page"
     */
    open func trackEvent(event: String){
        
        CyDataFetcher.sharedInstance.trackEventAPIRequest(eventName: event, completion: {
            cyPrint("Success trackEvent", event)
        }) { (error) in
            cyPrint("Error trackEvent", error)
        }
    }
    
    
    //MARK: Chat
    /*
     * Open the first view controller to the user, useful to chat with your Customer Support
     *
     */
    open func openSupport(from viewController: UIViewController){
        
        viewController.show(CustomerlyNavigationController(rootViewController: CustomerlyChatStartVC.instantiate()), sender: self)
    }
    
    //MARK: - CLOSED APIs
    //MARK: Ping
    func ping(){
        let pingRequestModel = CyRequestPingModel(JSON: [:])
        pingRequestModel?.params = [:]
        
        //if some cookies are stored, CyRequestPingModel containes these cookies and in this case the user information
        if let dataStored = CyStorage.getCyDataModel(){
            pingRequestModel?.settings?.user_id = dataStored.user?.user_id
            pingRequestModel?.settings?.email = dataStored.user?.email
            pingRequestModel?.settings?.name = dataStored.user?.name
            pingRequestModel?.cookies?.customerly_lead_token = dataStored.cookies?.customerly_lead_token
            pingRequestModel?.cookies?.customerly_temp_token = dataStored.cookies?.customerly_temp_token
            pingRequestModel?.cookies?.customerly_user_token = dataStored.cookies?.customerly_user_token
        }
        
        
        CyDataFetcher.sharedInstance.pingAPIRequest(pingModel: pingRequestModel, completion: { (responseData) in
            cyPrint("Success Ping")
            CyStorage.storeCyDataModel(cyData: responseData)
        }) { (error) in
            cyPrint("Error Ping", error)
        }
    }
    
    
}
