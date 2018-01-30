//
//  UIViewController.swift
//  Boop
//
//  Created by Sam Gehly on 11/16/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

extension UIViewController {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Test")
       view.endEditing(true);
    }

    func routeTo(identifier: String){
        self.dismiss(animated: true, completion: nil);
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: identifier)
        ivc.modalTransitionStyle = .crossDissolve
        ivc.modalPresentationStyle = .custom;
        self.present(ivc, animated: true, completion: nil)
    }
    
    func continuePrompt(title: String, message: String) -> Promise<Int> {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        return Promise { fulfill, reject in
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                fulfill(0);
            }
            let doAction = UIAlertAction(title: "OK", style: .cancel) { action in
                fulfill(1);
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(doAction)
            
            self.present(alertController, animated: true, completion: {})
        }
    }
    
    func prompt(title: String, message: String) -> Promise<Any?> {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
       
        
        return Promise { fulfill, reject in
        
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { action in
                fulfill(nil);
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: {})
        }
    }
    
    func showError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
