
//
//  LoginController.swift
//  Boop
//
//  Created by Sam Gehly on 11/16/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class LandingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendRegister(_ sender: UIButton) {
        print("Sending to Registry");
        self.routeTo(identifier: "register");
    }
    
}
