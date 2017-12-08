//
//  ViewController.swift
//  Boop
//
//  Created by Sam Gehly on 11/16/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import UIKit
import KeychainAccess;
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for fname in UIFont.familyNames{
            print(fname)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let keychain = Keychain(service: "sh.boop.login");
        let keychainIdentifier: String? = try! keychain.get("identifier");
        let keychainPassword: String? = try! keychain.get("password");
        
        
        if(keychainIdentifier != nil && keychainPassword != nil){
            login(identifier: keychainIdentifier, password: keychainPassword)
            .then{ response -> Void in
                self.routeTo(identifier: "authenticationNavigation");
            }
            .catch { error -> Void in
                self.showError(title: "Login Error", message: "It seems that we could not log you in with your stored details. Please sign in again.");
                self.routeTo(identifier: "authenticationNavigation");
            }
        }

        
        self.routeTo(identifier: "authenticationNavigation");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

