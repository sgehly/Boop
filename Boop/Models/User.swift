//
//  User.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation

class User {
    var username: String?;
    var displayName: String?;
    var phoneNumber: String?;
    
    
    init(username: String?, displayName: String?, phoneNumber: String?){
        self.username = username;
        self.displayName = displayName;
        self.phoneNumber = phoneNumber;
    }
}
