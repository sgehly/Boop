//
//  Interest.swift
//  Boop
//
//  Created by Sam Gehly on 1/7/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
class Interest: NSObject, NSCoding {
    
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
    
    required public init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.color = decoder.decodeObject(forKey: "color") as? UIColor ?? boopColor
        self.order = decoder.decodeObject(forKey: "order") as? Int ?? 0
        self.room = decoder.decodeObject(forKey: "room") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(color, forKey: "color")
        coder.encode(order, forKey: "order")
        coder.encode(room, forKey: "room")
    }
    
}
