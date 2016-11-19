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
    
    
    
    //MARK: - Public API
    
    //MARK: Configuration
    open func configure(secretKey: String){
        customerlySecretKey = secretKey
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
    
    //MARK: Ping
    open func ping(){
        let pingRequestModel = CyRequestPingModel(JSON: [:])
        pingRequestModel?.params = [:]
        
        CyDataFetcher.sharedInstance.pingAPIRequest(pingModel: pingRequestModel, completion: { (responseData) in
            cyPrint("Success Ping")
            cyPrint(responseData?.toJSONString() ?? "")
        }) { (error) in
            cyPrint("Error Ping", error)
        }
    }
    
    //MARK: Chat
    /*
     * Open the first view controller to the user, useful to chat with your Customer Support
     *
     */
    open func openSupport(from viewController: UIViewController){
        viewController.show(CustomerlyChatStartVC.instantiate(), sender: self)
    }
    
    //MARK: Utils
    func pingOK() -> Bool{
        
        return false
    }
    
    
}
