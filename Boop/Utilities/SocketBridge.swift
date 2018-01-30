//
//  SocketManager.swift
//  Boop
//
//  Created by Sam Gehly on 1/16/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketBridge {
    
    var manager: SocketManager? = nil;
    var socket: SocketIOClient? = nil;
    
    var liveView: HomeController? = nil;
    var replyView: ReplyViewController? = nil;
    
    func reconnect(){
        socket!.connect()
    }
    
    init(liveView: HomeController, replyView: ReplyViewController){
        self.liveView = liveView;
        self.replyView = replyView;
        manager = SocketManager(socketURL: URL(string: wsServer)!, config: [.log(true), .compress]);
        socket = manager?.defaultSocket;
        
        socket!.on(clientEvent: .connect){ data, ack in
            print("socket connected")
        }
        
        socket!.on("message"){ data, ack in
            let json = JSON(data.first!);
            print(json);
            let author = User(displayName: json["user"]["name"].stringValue, phoneNumber: nil, uuid: json["user"]["uuid"].stringValue, accessToken: nil);
            let message = Message(author: author, message: json["message"].stringValue);
            message.expires = Calendar.current.date(byAdding: Calendar.Component.second, value: 10, to: Date())
            self.liveView!.messageTable.addMessage(message: message);
        }
        
        self.reconnect();
    }
   /* func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Message received: ", text)
        processJSONObject(data: JSON(parseJSON: text));
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Data received", data);
        processJSONObject(data: JSON(data));
    }*/
}
