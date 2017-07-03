//
//  CySocket.swift
//  Customerly
//
//  Created by Paolo Musolino on 12/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import SocketIO

enum CySocketEvent: String {
    case typing = "typing"
    case message_seen = "seen"
    case message = "message"
}

class CySocket: NSObject {
    
    var socket: SocketIOClient?
    var actualOnMessage: UUID?
    
    //MARK: Init
    static let sharedInstance = CySocket() //Socket Client manager
    
    override init() {
        super.init()
    }
    
    func configure(){
        if let data = CyStorage.getCyDataModel(){
            if data.user?.crmhero_user_id != nil{
                if let websocketEndpoint = data.websocket?.endpoint, let websocketPort = data.websocket?.port{
                    let websocketUrl = URL(string:websocketEndpoint + ":" + websocketPort)
            
                    //Websocket token manipulation
                    let tokenData = data.websocket?.token?.base64Decoded()?.data(using: .utf8)
                    var tokenDictionary = JSONParseDictionary(data: tokenData)
                    tokenDictionary["socket_version"] = cy_socket_version
                    tokenDictionary["is_mobile"] = true
                    let tokenBase64 = DictionaryToJSONString(dictionary: tokenDictionary)?.base64Encoded()
                
                    //Extra params for back compatibility
                    let params = CyWebSocketParamsModel(JSON: ["app":Customerly.sharedInstance.customerlyAppId, "id":data.user!.crmhero_user_id!, "nsp":"user", "socket_version":cy_socket_version, "is_mobile":true])
                    
                    socket = SocketIOClient(socketURL: websocketUrl!, config: [.log(false), .secure(true), .forceNew(true), .connectParams(["token":tokenBase64 ?? "", "json": params!.toJSONString()!])]) //json parameter is for back compatibility
                }
            }
        }
    }
    
    //Reconfigure socket with new user
    func reconfigure(connected: ((Bool?) -> Void)? = nil){
        socket?.disconnect()
        configure()
        openConnection()
        
        socket?.on("connect") {data, ack in
            connected?(true)
        }
        
        socket?.on("error", callback: { (data, ack) in
            connected?(false)
        })
        
        socket?.on("disconnect", callback: { (data, ack) in
            connected?(false)
        })
    }
    
    //MARK: Open - Close Socket Connection
    func openConnection(){
        
        socket?.on("connect") {data, ack in
            cyPrint("Socket connected")
        }
        
        socket?.on("disconnect", callback: { (data, ack) in
            cyPrint("Socket disconnect")
        })
        
        socket?.on("error", callback: { (data, ack) in
            cyPrint("Socket error")
        })
        
        removeHandlerWithUUID(uuid: actualOnMessage)
        actualOnMessage = onMessage { (messageSocket) in
            Customerly.sharedInstance.realTimeMessagesClosure?(messageSocket)
        }
        
        socket?.connect()
    }
    
    func closeConnection(){
        socket?.disconnect()
        socket?.removeAllHandlers()
    }
    
    //MARK: Emit
    func emitTyping(typing : Bool, text_preview: String?, conversationId: Int?){
        
        guard conversationId != nil else {
            return
        }
        
        //Emit when user is typing
        let typingSocketModel = CyTypingSocketModel(JSON: [:])
        typingSocketModel?.conversation_id = conversationId
        typingSocketModel?.user_id = CyStorage.getCyDataModel()?.user?.crmhero_user_id
        
        typingSocketModel?.is_typing = typing == true ? "y" : "n"
        typingSocketModel?.typing_preview = text_preview
        
        if let json = typingSocketModel?.toJSON(){
            socket?.emit(CySocketEvent.typing.rawValue, with: [json])
        }
    }
    
    func emitMessage(message: String, timestamp: Int){
        //Emit when a message is sent
        let messageSocketModel = CyMessageSocketModel(JSON: [:])
        messageSocketModel?.timestamp = timestamp
        messageSocketModel?.user_id = CyStorage.getCyDataModel()?.user?.crmhero_user_id
        
        if let json = messageSocketModel?.toJSON(){
            socket?.emit(CySocketEvent.message.rawValue, with: [json])
        }
    }
    
    func emitSeen(messageId: Int?, timestamp: Int){
        //Emit when a message is seen
        let seenSocketModel = CySeenMessageSocketModel(JSON: [:])
        seenSocketModel?.seen_date = timestamp
        seenSocketModel?.conversation_message_id = messageId
        seenSocketModel?.user_id = CyStorage.getCyDataModel()?.user?.crmhero_user_id
        
        if let json = seenSocketModel?.toJSON(){
            socket?.emit(CySocketEvent.message_seen.rawValue, with: [json])
        }
    }
    
    //MARK: On
    func onTyping(typing: @escaping ((CyTypingSocketModel?) -> Void)) -> UUID?{
        //socket?.off(CySocketEvent.typing.rawValue) off all handlers under "typing"
        let uuid = socket?.on(CySocketEvent.typing.rawValue, callback: { (data, ack) in
            if !data.isEmpty{
                let typingModel = CyTypingSocketModel(JSON: data.first as! Dictionary)
                typing(typingModel)
            }
        })
        
        return uuid
    }
    
    func onMessage(message: @escaping ((CyMessageSocketModel?) -> Void)) -> UUID?{
        //socket?.off(CySocketEvent.message.rawValue) off all handlers under "message"
        let uuid = self.socket?.on(CySocketEvent.message.rawValue, callback: { (data, ack) in
            if !data.isEmpty{
                let messageModel = CyMessageSocketModel(JSON: data.first as! Dictionary)
                message(messageModel)
            }
        })
        
        return uuid
    }
    
    //MARK: - Utils
    func isConnected() -> Bool{
        if socket?.status == .connected{
            return true
        }
        
        return false
    }
    
    func removeHandlerWithUUID(uuid: UUID?){
        if uuid != nil{
            socket?.off(id: uuid!)
        }
    }
}
