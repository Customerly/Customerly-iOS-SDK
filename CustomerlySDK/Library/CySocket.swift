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
            print("socket connected", data)
        }
        
        socket?.on("disconnect", callback: { (data, ack) in
            print("socket disconnect", data)
        })
        
        socket?.on("error", callback: { (data, ack) in
            print("Errore", data)
        })
        
        socket?.connect()
    }
    
    func closeConnection(){
        socket?.disconnect()
    }
    
    //MARK: Emit
    func emitIsTyping(typing : Bool){
        let typingSocketModel = CyTypingSocketModel(JSON: [:])
        typingSocketModel?.conversation_id = 127626
        typingSocketModel?.user_id = 276036
        
        typingSocketModel?.is_typing = typing == true ? "y" : "n"
        
        if let json = typingSocketModel?.toJSON(){
            socket?.emit(CySocketEvent.typing.rawValue, with: [json])
        }
    }
    
    //MARK: On
}
