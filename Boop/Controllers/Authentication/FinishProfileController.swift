//
//  FinishProfileController.swift
//  Boop
//
//  Created by Sam Gehly on 12/4/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import UnderKeyboard
import KeychainAccess

class FinishProfileController: UIViewController {
    
    let keyboardConstraint = UnderKeyboardLayoutConstraint()
    let keyboardObserver = UnderKeyboardObserver()
    var originalExtraSpace: CGFloat = 0;
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var extraSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var displayName: UITextField!
    
    @IBAction func done(_ sender: Any) {
        postRequest(endpoint: "users/auth/final", body: [
            "displayName": displayName.text
        ])
        .then { response -> Void in
            
            currentUser!.setName(name: self.displayName.text!)
            
            setLogin(uuid: response["message"]["uuid"].stringValue, token: response["message"]["accessToken"].stringValue)
            
            self.navigationController?.dismiss(animated: true, completion: {
                self.routeTo(identifier: "boopNavigation");
            })
        }
        .catch { error -> Void in
                if let err = error as? BoopRequestError{
                    switch err{
                    case .HTTPError(let message):
                        self.showError(title: "Registration HTTP Error", message: message);
                        break;
                    case .BoopError(let code, let message):
                        self.showError(title: "Registration Error "+String(code), message: message);
                    }
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalExtraSpace = extraSpaceConstraint.constant;
        
        keyboardObserver.start()
        
        // Called before the keyboard is animated
        keyboardObserver.willAnimateKeyboard = { height in
            print(height);
            self.bottomConstraint.constant = -height

            if(height == 0){
                self.extraSpaceConstraint.constant = self.originalExtraSpace;
            }else{
                self.extraSpaceConstraint.constant = 30;
            }
        }
        
        keyboardObserver.animateKeyboard = { height in
            self.view.layoutIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
