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
    case ping_active = "a"
    case ping = "p"
}

class CySocket: NSObject {
    
    var socket : SocketIOClient?
    
    //MARK: Init
    static let sharedInstance = CySocket() //Socket Client manager
    
    override init() {
        super.init()
    }
    
    func configure(){
        if let data = CyStorage.getCyDataModel(){
            if let websocketEndpoint = data.websocket?.endpoint, let websocketPort = data.websocket?.port{
                let websocketUrl = URL(string:websocketEndpoint + ":" + websocketPort)
                
                let params = CyWebSocketParamsModel(JSON: ["app":Customerly.sharedInstance.customerlySecretKey, "id":data.user?.crmhero_user_id ?? -1, "nsp":"user"])
        
                socket = SocketIOClient(socketURL: websocketUrl!, config: [.log(true), .secure(false), .forceNew(true), .connectParams(["json":params!.toJSONString()!])])
            }
        }
    }
    
    //MARK: Open - Close Socket Connection
    func openConnection(){
        
        socket?.on("connect") {data, ack in
            cyPrint("socket connected")
        }
        
        socket?.on("disconnect", callback: { (data, ack) in
            cyPrint("socket disconnect")
        })
        
        socket?.on("error", callback: { (data, ack) in
            cyPrint("socket error")
        })
        
        socket?.connect()
    }
    
    func closeConnection(){
        socket?.disconnect()
    }
    
    //MARK: Emit
    func emitTyping(typing : Bool, conversationId: Int){
        let typingSocketModel = CyTypingSocketModel(JSON: [:])
        typingSocketModel?.conversation_id = conversationId
        typingSocketModel?.user_id = 276036 //TODO: user
        
        typingSocketModel?.is_typing = typing == true ? "y" : "n"
        
        if let json = typingSocketModel?.toJSON(){
            socket?.emit(CySocketEvent.typing.rawValue, with: [json])
        }
    }
    
    func emitMessage(message: String, timestamp : Int){
        let messageSocketModel = CyMessageSocketModel(JSON: [:])
        messageSocketModel?.timestamp = timestamp
        messageSocketModel?.user_id = 276036 //TODO: user
        
        if let json = messageSocketModel?.toJSON(){
            socket?.emit(CySocketEvent.message.rawValue, with: [json])
        }
    }
    
    //MARK: Emit Ping
    func emitPingActive(){
        //emit ping when user is focused on a view of customerly
        socket?.emit(CySocketEvent.ping_active.rawValue, [])
    }
    
    func emitPing(){
        //emit ping when user is not focused on a view of customerly
        socket?.emit(CySocketEvent.ping.rawValue, [])
    }
    
    //MARK: On
    func onTyping(typing: @escaping ((CyTypingSocketModel?) -> Void)){
        socket?.on(CySocketEvent.typing.rawValue, callback: { (data, ack) in
            if !data.isEmpty{
                let typingModel = CyTypingSocketModel(JSON: data.first as! Dictionary)
                typing(typingModel)
            }
        })
    }
    
    func onMessage(typing: @escaping ((CyMessageSocketModel?) -> Void)){
        socket?.on(CySocketEvent.message.rawValue, callback: { (data, ack) in
            if !data.isEmpty{
                let messageModel = CyMessageSocketModel(JSON: data.first as! Dictionary)
                typing(messageModel)
            }
        })
    }
}
