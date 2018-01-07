//
//  Message.swift
//  Boop
//
//  Created by Sam Gehly on 1/2/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation

class Message {
    
    var author: User;
    var message: String;
    var available: Bool;
    
    var timer: Timer?;
    
    
    func beginCountdown(){
        
    }
    
    init(author: User, message: String){
        self.author = author;
        self.message = message;
        self.available = false;
        self.timer = nil;
    }
}
