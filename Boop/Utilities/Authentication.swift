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

func login(identifier: String?, password: String?) -> Promise<Any?>{
    return Promise { fulfill, reject in
        
        postRequest(endpoint: "user/login", body: ["identifier":identifier, "password":password])
            .then { response -> Void in
                currentUser = User(username: response["message"]["username"]["username"].stringValue,
                                   displayName: response["message"]["username"]["name"].stringValue,
                                   phoneNumber: response["message"]["username"]["phone"].stringValue)
                fulfill(nil);
            }
            .catch { error in
                reject(error);
            }
    }
}
