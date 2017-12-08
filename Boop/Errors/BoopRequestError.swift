//
//  BoopRequestError.swift
//  Boop
//
//  Created by Sam Gehly on 11/29/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation

enum BoopRequestError: Error{
    case HTTPError(message: String);
    case BoopError(code: Int, message: String);
}
