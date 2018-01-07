//
//  HomeController.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import BAFluidView

class HomeController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet var header: UIView!
    @IBOutlet var messageTable: MessageTableView!
    var profileShouldComplete = false;
    var composer: Composer = Composer();
    var parentVC: BoopPageViewController? = nil;
        
    @IBOutlet var noMessageView: UIView!
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let user = User(displayName: "Kitty Kat", phoneNumber: nil, uuid: "123123123", accessToken: nil)
        messageTable.addMessage(message: Message(author: user, message: "Test Message 123456 We will we will rock you!"));
    }
    
    override func viewDidLoad(){
        super.viewDidLoad();
        messageTable.noView = noMessageView;
        self.parentVC = self.parent as? BoopPageViewController
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(composer.view);
    }
    
    func bringDownComposer(){
        parentVC?.dataSource = nil
        
        composer.cancelButton.addTarget(self, action: #selector(exitComposer), for: UIControlEvents.touchUpInside)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.composer.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        }, completion: {completed in })
        self.composer.textField.becomeFirstResponder();
    }
    
    @objc func exitComposer(){
        parentVC?.dataSource = parentVC
        UIView.animate(withDuration: 0.25, animations: {
            self.composer.view.frame = CGRect(x: 0, y: -self.composer.view.frame.height, width: self.view.frame.width, height: self.composer.view.frame.height);
        }, completion: {completed in })
    }
    
    @IBAction func tapWrite(_ sender: UIButton) {
        bringDownComposer();
    }
    
    
    @IBAction func goToProfile(_ sender: Any) {
        let parent = self.parent as! BoopPageViewController
        parent.changePage(toIndex: 2)
    }
    
    @IBAction func goToReplies(_ sender: Any) {
        let parent = self.parent as! BoopPageViewController
        parent.changePage(toIndex: 0)
    }
    
}
