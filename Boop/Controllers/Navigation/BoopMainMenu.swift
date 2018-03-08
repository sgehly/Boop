//
//  BoopMainMenu.swift
//  Boop
//
//  Created by Sam Gehly on 3/7/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class BoopMainMenu: UIViewController{
    @IBOutlet var colorBox: UIView!
    
    
    convenience init(){
        self.init();
        colorBox.clipsToBounds = true;
        colorBox.layer.masksToBounds = true;
        colorBox.layer.cornerRadius = colorBox.frame.height/2;
    }
    
    override func viewDidLoad() {
        colorBox.clipsToBounds = true;
        colorBox.layer.masksToBounds = true;
        colorBox.layer.cornerRadius = colorBox.frame.height/2;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
       
    }
}
