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
                currentUser = User(displayName: response["message"]["name"].stringValue,
                                   phoneNumber: response["message"]["phone"].stringValue,
                                   uuid: uuid,
                                   accessToken: token)
                fulfill(nil);
            }
            .catch { error in
                reject(error);
            }
    }
}

//For setting known credentials
func setLogin(uuid: String, token: String){
    let keychain = Keychain(service: "sh.boop.login");
    do{
        try keychain.set(uuid, key: "identifier");
        try keychain.set(token, key: "token")
    }
    catch let error{
        print(error);
    }
}
