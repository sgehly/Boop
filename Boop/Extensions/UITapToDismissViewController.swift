//
//  UITapToDismissViewController.swift
//  Boop
//
//  Created by Sam Gehly on 2/19/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class UITapToDismissViewController: UIViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
}
