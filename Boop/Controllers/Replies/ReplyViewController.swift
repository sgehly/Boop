//
//  ReplyViewController.swift
//  Boop
//
//  Created by Sam Gehly on 1/4/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class ReplyViewController: UIViewController{
    
    @IBAction func backToHome(_ sender: Any) {
        print("ET GO HOME")
        let parent = self.parent as! BoopPageViewController;
        parent.changePage(toIndex: 1);
    }
    
}
