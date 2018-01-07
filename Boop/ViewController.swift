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
            //print(fname)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.routeTo(identifier: "boopNavigation");
        return
        
        let keychain = Keychain(service: "sh.boop.login");
        let uuid: String? = try! keychain.get("identifier");
        let token: String? = try! keychain.get("password");
        
        if(uuid != nil && token != nil){
            tryLogin(uuid: uuid!, token: token!)
            .then{ response -> Void in
                self.routeTo(identifier: "boopNavigation");
            }
            .catch { error -> Void in
                self.prompt(title: "Login Error", message: "It seems that we could not log you in with your stored details. Please sign in again.")
                .then { response in
                    self.routeTo(identifier: "authenticationNavigation");
                }
            }
        }else{
             print("Going to auth nav!");
            self.routeTo(identifier: "authenticationNavigation");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

