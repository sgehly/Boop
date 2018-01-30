//
//  ViewController.swift
//  Boop
//
//  Created by Sam Gehly on 11/16/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import UIKit
import KeychainAccess;

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for fname in UIFont.familyNames{
            //print(fname)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

