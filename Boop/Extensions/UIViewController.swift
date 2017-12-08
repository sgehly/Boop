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
    
    func dismissTapAround(){
        let dismissKeyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        dismissKeyboardTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func routeTo(identifier: String){
        
        self.dismiss(animated: true, completion: nil);
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: identifier)
        ivc.modalTransitionStyle = .crossDissolve
        ivc.modalPresentationStyle = .custom;
        self.present(ivc, animated: true, completion: nil)
    }
    
    func navigationRouteBack(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false);
    }
    
    func navigationRouteTo<T>(identifier: String, controller: T){
        
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! T
        
        let controllerCast = nvc as! UIViewController
        
        controllerCast.modalTransitionStyle = .crossDissolve
        controllerCast.modalPresentationStyle = .custom;
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(controllerCast, animated: false);

    }
    
    func prompt(title: String, message: String) -> Promise<Any?> {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
       
        
        return Promise { fulfill, reject in
        
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { action in
                fulfill(nil);
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: {
                fulfill(nil);
            })
        }
    }
    
    func showError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
