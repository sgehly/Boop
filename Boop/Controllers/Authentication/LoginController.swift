//
//  LoginController.swift
//  Boop
//
//  Created by Sam Gehly on 11/18/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet var titleBox: UIView!
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveToPhoneEntry(_ sender: Any) {
        let parent = self.navigationController!.parent! as! AuthenticationSingularity;
        parent.changeToRed();
        self.navigationController!.go(to: "register", withController: RegistrationController())
    }
}
