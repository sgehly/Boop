//
//  UIFadeSegue.swift
//  Boop
//
//  Created by Sam Gehly on 11/18/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class UIFadeInSegue: UIStoryboardSegue {
    
    var animated: Bool = true
    
    override func perform() {
        
        if let sourceViewController = self.source as? UIViewController, let destinationViewController = self.destination as? UIViewController {
            
            let transition: CATransition = CATransition()
            
            transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            sourceViewController.view.window?.layer.add(transition, forKey: "kCATransition")
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
            
            
        }
    }
    
}

class UIFadeOutSegue: UIStoryboardSegue {
    
    override func perform() {
        
        if let sourceViewController = self.source as? UIViewController, var _ = self.destination as? UIViewController {
            
            let transition: CATransition = CATransition()
            
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            
            sourceViewController.view.window?.layer.add(transition, forKey: "kCATransition")
            sourceViewController.navigationController?.popViewController(animated: false)
        }
    }
    
}
