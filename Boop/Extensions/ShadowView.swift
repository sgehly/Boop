//
//  ShadowView.swift
//  Boop
//
//  Created by Sam Gehly on 1/15/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
class ShadowView: UIView{
    
    func assignShadow(){
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.clipsToBounds = true;
        self.layer.masksToBounds = true;
        self.generateOuterShadow();
    }
    override func awakeFromNib() {
        assignShadow();
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        assignShadow();
        
    }
}
