//
//  CySocket.swift
//  Customerly
//
//  Created by Paolo Musolino on 12/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import SocketIO

enum CySocketEvents: String {
    case typing = "typing"
    case message_seen = "seen"
    case message = "message"
}

class CySocket: NSObject {
    
    var socket : SocketIOClient? //SocketIOClient manager
    
    //MARK: Init
    static let sharedInstance = CySocket()
    
    //MARK: Init
    override init() {
        super.init()
        if let data = CyStorage.getCyDataModel(){
            if let websocketEndpoint = data.websocket?.endpoint, let websocketPort = data.websocket?.port{
                let websocketUrl = websocketEndpoint + ":" + websocketPort
                
                let params = ["nsp":"user", "app":Customerly.sharedInstance.customerlySecretKey, "id":data.user?.crmhero_user_id]
                
                socket = SocketIOClient(socketURL: URL(string: websocketUrl)!, config: [.log(true), .forcePolling(false), .secure(true), .forceNew(true), .connectParams(params)])
                socket.connect()
            }
        }
    }
}
