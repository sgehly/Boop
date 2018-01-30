//
//  PillButton.swift
//  Boop
//
//  Created by Sam Gehly on 12/8/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class PillButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true;
    }
}
