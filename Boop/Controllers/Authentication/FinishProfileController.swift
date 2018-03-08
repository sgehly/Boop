//
//  FinishProfileController.swift
//  Boop
//
//  Created by Sam Gehly on 12/4/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class FinishProfileController: UITapToDismissViewController {
    
    var originalExtraSpace: CGFloat = 0;
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var extraSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var displayName: UITextField!
    
    @IBOutlet var finishButton: PillButton!
    
    @IBAction func done(_ sender: Any) {
        
        finishButton.disable();
        displayName.disable();
        
        postRequest(endpoint: "users/auth/final", body: [
            "displayName": displayName.text
        ])
        .then { response -> Void in
            
            self.finishButton.enable();
            self.displayName.enable();
            
            currentUser!.setName(name: self.displayName.text!)
            
            currentUser!.setLogin(uuid: response["message"]["uuid"].stringValue, token: response["message"]["accessToken"].stringValue)
            
            self.navigationController!.parent!.navigationController!.goRootAndPresent(to: "mainNav", withController: GlobalBoopNavigation())
            self.navigationController!.parent!.dismiss(animated: true, completion: nil)
        }
        .catch { error -> Void in
            
            self.finishButton.enable();
            self.displayName.enable();
            
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
