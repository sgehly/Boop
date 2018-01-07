//
//  ProfileViewController.swift
//  Boop
//
//  Created by Sam Gehly on 1/3/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet var pic: UIImageView!
    
    var creator: InterestCreator = InterestCreator();
    var parentVC: BoopPageViewController? = nil;
    
    override func viewDidLoad() {
        parentVC = self.parent as! BoopPageViewController;
        pic.layer.cornerRadius = pic.frame.height/2;
        pic.clipsToBounds = true;
        pic.layer.masksToBounds = true;
        self.view.addSubview(creator.view);
    }
    
    
    func enterCreator(){
        
        parentVC?.dataSource = nil
        
        print(creator.cancelButton);
        creator.cancelButton.addTarget(self, action: #selector(exitCreator), for: UIControlEvents.touchUpInside)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.creator.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        }, completion: {completed in })
        self.creator.interestField.becomeFirstResponder();
    }
    
    @objc func exitCreator(){
        
        parentVC?.dataSource = parentVC
        
        UIView.animate(withDuration: 0.25, animations: {
            self.creator.view.frame = CGRect(x: 0, y: -self.creator.view.frame.height, width: self.view.frame.width, height: self.creator.view!.frame.height);
        }, completion: {completed in })
    }
    
    @IBAction func tapAdd(_ sender: UIButton) {
        enterCreator();
    }
    
    @IBAction func backToHome(_ sender: Any) {
        let parent = self.parent as! BoopPageViewController;
        parent.changePage(toIndex: 1);
    }
    
}
