//
//  HTTP.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit
import Alamofire

func postRequest(endpoint: String, body: [String: Any]) -> Promise<JSON>{
    
    return Promise { fulfill, reject in
       // print("Post Internal 1");
        Alamofire.request(apiBase+endpoint, method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                //print("Post Internal 2");
                let jsonResponse: JSON = JSON(response.data);
                if(jsonResponse["success"].boolValue){
                    fulfill(jsonResponse);
                }else{
                    if(response.response == nil || response.data == nil){
                        reject(BoopRequestError.HTTPError(message: "An unknown HTTP error ocurred."));
                    }else{
                        reject(BoopRequestError.BoopError(code: response.response!.statusCode, message: jsonResponse["error"].stringValue));
                    }
                }
            }
    }
}
func getRequest(endpoint: String) -> Promise<JSON>{
    return Promise { fulfill, reject in
        Alamofire.request(apiBase+endpoint)
            .responseJSON { response in
                let jsonResponse: JSON = JSON(response.data);
                if(jsonResponse["success"].boolValue){
                    fulfill(jsonResponse);
                }else{
                    if(response.response == nil || response.data == nil){
                        reject(BoopRequestError.HTTPError(message: "An unknown HTTP error ocurred."));
                    }else{
                        reject(BoopRequestError.BoopError(code: response.response!.statusCode, message: jsonResponse["error"].stringValue));
                    }
                }
        }
    }
}
