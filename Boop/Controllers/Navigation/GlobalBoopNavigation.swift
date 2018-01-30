//
//  GlobalBoopNavigation.swift
//  Boop
//
//  Created by Sam Gehly on 1/18/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class GlobalBoopNavigation: UIViewController, UIScrollViewDelegate{

    @IBOutlet var profileButton: UIButton!
    @IBOutlet var composeButton: UIButton!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var colorBGView: UIView!
    @IBOutlet var containerView: UIView!
    
    var pageController: BoopPageViewController? = nil;
    init(){
        super.init(nibName: "mainNav", bundle: Bundle.main)
    }
    
    @IBAction func interestTap(_ sender: Any) {
        pageController!.changePage(toIndex: 2)
    }
    
    @IBAction func composeTap(_ sender: Any) {
        if(pageController!.index == 1){
            let homeController = pageController?.pages[1] as! HomeController;
            homeController.bringDownComposer();
            return;
        }
        pageController!.changePage(toIndex: 1)
    }
    
    @IBAction func replyTap(_ sender: Any) {
        pageController!.changePage(toIndex: 0)
    }
    
    override func viewDidLayoutSubviews() {
        pageController = self.childViewControllers.last! as! BoopPageViewController
         let scrollView = pageController!.view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
        scrollView.delegate = self as! UIScrollViewDelegate
        
        containerView.cornerAndBorder(sides: [.top,.bottom], corners: [], color: transparent, thickness: 1, cornerRadius: 0)
    }
    
    
    
    var isTransitioning = false;
    var isMovingBackwards = false;
    
    func processButtons(buttonArray: [UIButton], percentComplete: CGFloat){
        var percentage = percentComplete;
        if(isMovingBackwards){
            percentage = 1-percentage;
        }
        
        for button in buttonArray{
            var faded: CGFloat = 0.25;
            if(buttonArray.index(of: button) == pageController!.tempIndex){
                button.alpha = faded+((1-faded)*abs(percentage))
            }else{
                if(button.alpha-((1-faded)*abs(percentage)) > faded){
                    button.alpha = button.alpha-((1-faded)*abs(percentage))
                }
                else if(button.alpha != faded){
                    button.alpha = faded;
                }
            }
        }
        
        /*if(percentage > 0.5){
            if(pageController!.tempIndex == 2){
                colorBGView.backgroundColor = greenColor;
                colorBGView.alpha = (percentage-(0.5))*1;
            }else{
                colorBGView.alpha = 1-((percentage-(0.5))*1);
            }
        }*/
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        var buttonArray: [UIButton] = [replyButton, composeButton, profileButton];

        percentComplete = abs((point.x - view.frame.size.width)/view.frame.size.width)
        if(percentComplete > 1){
            percentComplete = 1;
        }
        
        //print("from", pageController!.lastIndex, "to", pageController!.tempIndex, "RI:", pageController!.index, percentComplete)
        
        if(pageController!.lastIndex == pageController!.tempIndex){
            return
        }
        
        if(pageController!.lastIndex == pageController!.tempIndex && percentComplete != 0){
            processButtons(buttonArray: buttonArray, percentComplete: percentComplete)
            return;
        }
        
        if(percentComplete < pageController!.lastPercentage && !isMovingBackwards){
            isMovingBackwards = true;
            var theAttempt = pageController!.tempIndex
            pageController!.tempIndex = pageController!.lastIndex;
            pageController!.lastIndex = theAttempt;
            pageController!.lastPercentage = 0;
        }
        if(percentComplete > pageController!.lastPercentage && isMovingBackwards){
            isMovingBackwards = false;
            var theAttempt = pageController!.tempIndex;
            pageController!.tempIndex = pageController!.lastIndex;
            pageController!.lastIndex = theAttempt;
            pageController!.lastPercentage = 0;
        }
        
        pageController!.lastPercentage = percentComplete;
        
        if(percentComplete == 1){
            //print("Finished switch from", pageController!.lastIndex, "to", pageController!.tempIndex)
            pageController!.index = pageController!.tempIndex;
            pageController!.lastIndex = pageController!.tempIndex;
            percentComplete = 0;
            return;
        }
        
        processButtons(buttonArray: buttonArray, percentComplete: percentComplete)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(nibName: "mainNav", bundle: Bundle.main);
        super.init(coder: aDecoder)
    }
}
