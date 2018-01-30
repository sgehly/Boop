//
//  AuthenticationNavigationController.swift
//  Boop
//
//  Created by Sam Gehly on 11/18/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class AuthenticationNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        let keychain = Keychain(service: "sh.boop.login");
        
        let data = UserDefaults.standard.object(forKey: "user");
        
        var potentialUser: User? = nil
        
        if(data != nil){
            potentialUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? User
        }
        
        
        var token: String? = nil;
        do {
            try token = keychain.get("token")
        }
        catch let error{
            print(error)
        }
        if(potentialUser != nil && token != nil && potentialUser?.uuid != nil){
            tryLogin(uuid: potentialUser!.uuid!, token: token!)
                .then { response -> Void in
                    currentUser = potentialUser!
                    self.go(to: "mainNav", withController: GlobalBoopNavigation())
                }
                .catch { error -> Void in
                    UserDefaults.standard.removeObject(forKey: "user");
                    self.prompt(title: "Login Error", message: "It seems that we could not log you in with your stored details. Please sign in again.")
                        .then { response in
                            self.go(to: "authSPA", withController: AuthenticationSingularity())
                    }
            }
        }else{
            print("Going to auth nav!");
            self.go(to: "authSPA", withController: AuthenticationSingularity())
        }
    }
}
