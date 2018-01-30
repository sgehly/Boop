//
//  UINavigationController.swift
//  Boop
//
//  Created by Sam Gehly on 1/8/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    
    func goRootAndPresent<T>(to: String, withController: T){
        print("Go root and change!")
        self.popToRootViewController(animated: true);
        
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: to) as! T
        
        let controllerCast = nvc as! UIViewController
        
        controllerCast.modalTransitionStyle = .crossDissolve
        controllerCast.modalPresentationStyle = .custom;
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(controllerCast, animated: false)
    }
    
    func go<T>(to: String, withController: T){
        
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: to) as! T
        
        let controllerCast = nvc as! UIViewController
        
        controllerCast.modalTransitionStyle = .crossDissolve
        controllerCast.modalPresentationStyle = .custom;
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(controllerCast, animated: false);
        
    }
    
    func goBack(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false);
    }
}
