//
//  User.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation

class User {
    private(set) var displayName: String?;
    private(set) var phoneNumber: String?;
    private(set) var uuid: String?;
    private(set) var accessToken: String?;
    private(set) var interests: [Interest] = [];
    
    init(displayName: String?, phoneNumber: String?, uuid: String?, accessToken: String?){
        self.displayName = displayName;
        self.phoneNumber = phoneNumber;
        self.uuid = uuid;
        self.accessToken = accessToken;
        self.save();
    }
    
    func save(){
        let defaults = UserDefaults.standard
        defaults.set(self, forKey: "authedUser")
    }
    
    func addInterest(interest: Interest){
        self.interests.append(interest);
        self.save();
    }
    
    func setName(name: String){
        self.displayName = name;
        self.save();
    }
    
}
