//
//  HomeController.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController{
    
    @IBOutlet var content: UIScrollView!;
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }
    
    convenience init(){
        self.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
