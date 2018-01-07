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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
                
        let replies: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "replies")
        
        let live: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "live")
        
        let profile: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "profile")
        
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
        index = toIndex
        setViewControllers([pages[toIndex]], direction: dir, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if(!doScroll){
            return nil;
        }
        
        let currentIndex = pages.index(of: viewController)!
        print("Index After", currentIndex, pages.count)
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        print("Index Check", pages.index(of: previousViewControllers[0]), pages.index(of: self.viewControllers![0]))
        index = pages.index(of: self.viewControllers![0])!
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
