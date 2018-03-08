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

class HomeController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet var header: UIView!
    @IBOutlet var messageTable: MessageTableView!
    @IBOutlet var interestViewWrapper: UIView!
    var profileShouldComplete = false;
    var composer: Composer? = nil;
    var parentVC: BoopPageViewController? = nil;
    var observer: Any? = nil;
    var menuOpen: Bool = false;

    
    
    var generator = UIImpactFeedbackGenerator(style: .heavy)
    
    @IBOutlet var gradientContainer: UIView!
    @IBOutlet var interestShadowView: UIView!
    @IBOutlet var noMessageView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        composer!.reset();
    }
    
    @IBOutlet var interestCollectionView: InterestCollectionView!
    
    
    func openMenu(){
        let boopNav = parentVC!.navigationParent!;
        print("Menu Open")
        menuOpen = true;
        
        self.messageTable.isUserInteractionEnabled = false;
        
        for view in self.messageTable.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = false;
            }
        }
        
        for view in parentVC!.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.bounces = false;
                scrollView.isScrollEnabled = false;
            }
        }
        
        UIView.animate(withDuration: TimeInterval(0.2), animations: {
            self.view.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
            boopNav.menu.view.frame = CGRect(x: 0, y: boopNav.menu.view.frame.minY, width: self.view.frame.width/2, height: boopNav.menu.view.frame.height);
        }, completion: { completed in
            //self.parentVC!.dataSource = nil;
            //self.view.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
           // boopNav.menu.view.frame = CGRect(x: 0, y: boopNav.menu.view.frame.minY, width: boopNav.menu.view.frame.width, height: boopNav.menu.view.frame.height);
        })
    }
    
    func closeMenu(){
        menuOpen = false;
        let boopNav = parentVC!.navigationParent!;
        print("Menu Close")
        
        self.messageTable.isUserInteractionEnabled = true;
        
        for view in self.messageTable.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = true;
            }
        }
        for view in self.parentVC!.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.bounces = true;
                scrollView.isScrollEnabled = true;
            }
        }
        
        UIView.animate(withDuration: TimeInterval(0.2), animations: {
            self.view.frame = CGRect(x: 0, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
            boopNav.menu.view.frame = CGRect(x: self.view.frame.minX-boopNav.menu.view.frame.width, y: boopNav.menu.view.frame.minY, width: boopNav.menu.view.frame.width, height: boopNav.menu.view.frame.height);
        }, completion: { completed in
        })
    }
    
    @objc func openMenu(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: self.view)
        
        if gestureRecognizer.state == .ended{
            print("Ended");
            
            if(self.view.frame.minX > self.view.frame.width/6 && !menuOpen){
                openMenu()
            }
            
            if(self.view.frame.minX < self.view.frame.width/6 && !menuOpen){
                closeMenu();
            }
            
            if(self.view.frame.minX < self.view.frame.width/2 && menuOpen){
                closeMenu()
            }
            
            //gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)

        }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let boopNav = parentVC!.navigationParent!;
            
            if(self.view.frame.minX < 0 || self.view.frame.minX > self.view.frame.width/2){
                if(self.view.frame.minX > self.view.frame.width/6 && translation.x > 0){
                   // openMenu();
                    return;
                }
                
                if(self.view.frame.minX < self.view.frame.width/6 && translation.x < 0){
                    //closeMenu();
                    return;
                }
                
            }
                        
            if(translation.x > 0){
                self.messageTable.isUserInteractionEnabled = false;
                
                for view in self.messageTable.subviews {
                    if let scrollView = view as? UIScrollView {
                        scrollView.isScrollEnabled = false;
                    }
                }
                
                for view in parentVC!.view.subviews {
                    if let scrollView = view as? UIScrollView {
                        scrollView.bounces = false;
                        scrollView.isScrollEnabled = false;
                    }
                }
            }
            
            if(self.view.frame.minX + translation.x < 15){
                return;
            }
            self.view.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y)
            
            if(self.view.frame.minX < 0){
                print("Setting to 0");
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
            
            boopNav.menu.view.frame = CGRect(x: gestureRecognizer.view!.frame.minX-boopNav.menu.view.frame.width, y: boopNav.menu.view.frame.minY, width: boopNav.menu.view.frame.width, height: boopNav.menu.view.frame.height);

            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc func openMenuSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        if(gestureRecognizer.direction == .right && !menuOpen){
            openMenu();
        }
        
        if(gestureRecognizer.direction == .left && menuOpen){
            closeMenu();
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.parentVC = self.parent as? BoopPageViewController

        let drag = UIPanGestureRecognizer(target: self, action: #selector(self.openMenu(_:)))
        drag.delegate = self;
        self.view.addGestureRecognizer(drag)
        
        
        messageTable.noView = noMessageView;
        messageTable.delegate = self;
        
        var messageArray = ["Test Message For Designing", "Test test test test test test test test test test test test Test test test test test test test test test test test test", "Ayy Lmao", "Cool Beans my guy - bork bork!"]
        
        for _ in 0..<10{
            let author = User(displayName: "Sam Gehly", phoneNumber: nil, uuid: "sgehly", accessToken: nil);
            let randomIndex = Int(arc4random_uniform(UInt32(messageArray.count)))
            let message = Message(author: author, message:messageArray[randomIndex])
            messageTable.addMessage(message: message)
        }
        
        
        composer = Composer(parent: self);
        self.view.addSubview(composer!.view);
        
        /*interestViewWrapper.layer.masksToBounds = true;
        interestViewWrapper.clipsToBounds = true;
        interestViewWrapper.layer.borderColor = transparent.cgColor
        interestViewWrapper.layer.borderWidth = 1;
        
        interestCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        print("HEYO", self.view.frame.height-interestViewWrapper.frame.minY);*/
        messageTable.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        
    }
    func bringDownComposer(){
        parentVC?.dataSource = nil
        composer!.animateDown();
    }
    
    @objc func exitComposer(){
        parentVC?.dataSource = parentVC
    }
    
    var previousScrollMoment: Date = Date()
    var previousScrollX: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= -200 {
            generator.impactOccurred();
            bringDownComposer()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageTable.cells[indexPath.row].getHeight();
    }
    
}
