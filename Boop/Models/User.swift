//
//  User.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import KeychainAccess
@objc(User) public class User: NSObject, NSCoding {
    
    private(set) var displayName: String?;
    private(set) var phoneNumber: String?;
    private(set) var uuid: String?;
    private(set) var accessToken: String?;
    private(set) var interests: [Interest] = [];
    
    init(displayName: String?, phoneNumber: String?, uuid: String?, accessToken: String?){
        super.init()
        self.displayName = displayName;
        self.phoneNumber = phoneNumber;
        self.uuid = uuid;
        self.accessToken = accessToken;
    }
    
    required public init(coder decoder: NSCoder) {
        self.displayName = decoder.decodeObject(forKey: "displayName") as? String ?? ""
        self.phoneNumber = decoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        self.uuid = decoder.decodeObject(forKey: "uuid") as? String ?? ""
        self.interests = decoder.decodeObject(forKey: "interests") as? [Interest] ?? []
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(displayName, forKey: "displayName")
        coder.encode(phoneNumber, forKey: "phoneNumber")
        coder.encode(uuid, forKey: "uuid")
        coder.encode(interests, forKey: "interests")
    }
    
    //For setting known credentials
    func setLogin(uuid: String, token: String){
        self.accessToken = token;
        let keychain = Keychain(service: "sh.boop.login");
        do{
            try keychain.set(token, key: "token")
        }
        catch let error{
            print(error);
        }
        self.uuid = uuid;
        self.save();
    }
    
    func save(){
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey:"user")
        UserDefaults.standard.synchronize()
    }
    
    func clearInterests(){
        self.interests = [];
        self.save();
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
