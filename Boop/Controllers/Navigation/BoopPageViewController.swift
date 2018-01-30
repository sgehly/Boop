//
//  BoopPageViewController.swift
//  Boop
//
//  Created by Sam Gehly on 1/4/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class BoopPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages: [UIViewController] = [];
    var doScroll = true;
    var index: Int = 1;
    var lastIndex: Int = 1;
    var tempIndex: Int = 1;
    var lastPercentage: CGFloat = 0;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.delegate = self
        self.dataSource = self
        
        let replies: ReplyViewController! = storyboard!.instantiateViewController(withIdentifier: "replies") as! ReplyViewController
        
        let live: HomeController! = storyboard!.instantiateViewController(withIdentifier: "live") as! HomeController
        
        let profile: UIViewController! = storyboard!.instantiateViewController(withIdentifier: "profile")
        
        socketManager = SocketBridge(liveView: live, replyView: replies);

        pages.append(replies)
        pages.append(live)
        pages.append(profile)

        
        setViewControllers([live], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func changePage(toIndex: Int){
        var dir = UIPageViewControllerNavigationDirection.forward;
        if(toIndex < index){
            dir = .reverse
        }
        lastIndex = index;
        tempIndex = toIndex;
        setViewControllers([pages[toIndex]], direction: dir, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if(!doScroll){
            return nil;
        }
        
        let currentIndex = pages.index(of: viewController)!
        if(currentIndex+1 < pages.count){
            return pages[currentIndex+1];
        }else{
            return nil;
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if(!doScroll){
            return nil;
        }
        let currentIndex = pages.index(of: viewController)!
        
        if(currentIndex-1 >= 0){
            return pages[currentIndex-1];
        }else{
            return nil;
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        tempIndex = pages.index(of: pendingViewControllers.first!)!;
        lastPercentage = 0;
        //print("Switching from", lastIndex, "to", tempIndex)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
