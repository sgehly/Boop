//
//  Authentication.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import PromiseKit
import KeychainAccess;

//For trying unknown credentials
func tryLogin(uuid: String, token: String) -> Promise<Any?>{
    return Promise { fulfill, reject in
        let keychain = Keychain(service: "sh.boop.login");

        postRequest(endpoint: "users/auth/login", body: ["uuid": uuid, "token": token])
            .then { response -> Void in
                print("Logged in!")
                fulfill(nil);
            }
            .catch { error in
                reject(error);
            }
    }
}
