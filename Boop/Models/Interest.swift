//
//  Interest.swift
//  Boop
//
//  Created by Sam Gehly on 1/7/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
class Interest{
    
    var name: String
    var color: UIColor
    var order: Int
    var room: String;
    
    init(name: String, color: UIColor, order: Int){
        
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+-=[]\';\"?".characters)
        
        self.name = name;
        self.color = color;
        self.order = order;
        self.room = name.lowercased()
                        .replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
                        .filter{okayChars.contains($0)}
    }
    
}
