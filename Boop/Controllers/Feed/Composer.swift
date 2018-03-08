//
//  Composer.swift
//  Boop
//
//  Created by Sam Gehly on 1/4/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import UITextView_Placeholder
import SwiftyGiphy

class Composer: UIViewController, UITextViewDelegate {
    
    @IBOutlet var promoteLabel: UILabel!
        
    @IBOutlet var yarnCount: UILabel!
    
    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var charRemaining: UILabel!
    
    @IBOutlet var timeTotal: UILabel!
    
    @IBOutlet var textField: UITextView!
    
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var timeSlider: UISlider!
    
    @IBOutlet var sponsoredSwitch: UISwitch!
    
    @IBOutlet var anonSwitch: UISwitch!
    
    @IBOutlet var replyView: UIView!
    @IBOutlet var replyText: UILabel!
    
    
    @IBOutlet var timeView: UIView!
    @IBOutlet var promoteView: UIView!
    @IBOutlet var anonymousView: UIView!
    @IBOutlet var gifView: UIView!
    @IBOutlet var locationView: UIView!
    
    @IBOutlet var timeButton: UIButton!
    @IBOutlet var sponsorButton: UIButton!
    @IBOutlet var anonButton: UIButton!
    @IBOutlet var gifButton: UIButton!
    @IBOutlet var locButon: UIButton!
    @IBOutlet var textButton: UIButton!
    
    @IBOutlet var interestView: InterestCollectionView!;
    
    @IBOutlet var giphyController: SwiftyGiphyViewController? = nil;
    
    
    var replyingTo: Message? = nil;
    
    
    var cost: Int = 0;
    var timeCost: Int = 0;
    var promoteCost: Int = 0;
    var anonCost: Int = 50;
    
    var keyboardHeight = 0;
    
    var keyboardAppearObserver: Any = "";
    var keyboardDisappearObserver: Any = "";
    
    var parentVC: HomeController? = nil;
    
    @IBOutlet var cancelButton: UIButton!

    @IBAction func sendMessage(_ sender: Any) {
        print("Sending message...");
        self.cancelButton.disable();
        self.postButton.disable();
        self.textField.disable();
        //self.timeSlider.disable();
        //self.anonSwitch.disable();
        //self.sponsoredSwitch.disable();
        self.textField.resignFirstResponder();
        postRequest(endpoint: "messages/send", body: [
            "message": textField.text
        ])
        .then { response -> Void in
            self.close();
        }
        .catch { error in
            self.cancelButton.enable();
            self.postButton.enable();
            self.textField.enable();
            //self.timeSlider.enable();
            //self.anonSwitch.enable();
            //self.sponsoredSwitch.enable();
            self.textField.becomeFirstResponder();
            if let err = error as? BoopRequestError{
                switch err{
                case .HTTPError(let message):
                    self.showError(title: "HTTP Error", message: message);
                    break;
                case .BoopError(let code, let message):
                    self.showError(title: "Send Error "+String(code), message: message);
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.superview!.superview!.frame.height);
        }, completion: {completed in
           
        })
    }
    
    var viewArray: [UIView] = [];
    var buttonArray: [UIButton] = [];
    
    var active = -1;
    
    
    @IBAction func backToText(_ sender: UIButton) {
        active = -1;
        
        self.textField.fade(to: 1, duration: 0.3)
        self.textField.isUserInteractionEnabled = true;
        
        sender.fade(to: 0.1, duration: 0.2)
        textButton.fade(to: 1, duration: 0.3)
        for button in buttonArray{
           button.fade(to: 0.1, duration: 0.2)
        }
        for view in viewArray{
            view.fade(to: 0, duration: 0.3)
            view.isUserInteractionEnabled = false;
        }
    }
    
    @IBAction func switchTab(_ sender: UIButton) {
        var index = buttonArray.index(of: sender);
        
        if(index == active){
            index = -1;
            active = -1;
            self.textField.fade(to: 1, duration: 0.3)
            self.textField.isUserInteractionEnabled = true;
            sender.fade(to: 0.1, duration: 0.3)
            textButton.fade(to: 1, duration: 0.3)
        }else{
            textButton.alpha = 0.1;
            self.textField.fade(to: 0, duration: 0.3)
            self.textField.isUserInteractionEnabled = false;
        }
        
        
        for (i, view) in viewArray.enumerated(){
            
            if(i == index){
                view.fade(to: 1, duration: 0.3)
                view.isUserInteractionEnabled = true;
            }else{
                view.fade(to: 0, duration: 0.3)
                view.isUserInteractionEnabled = false;
            }
        }
        
        for button in buttonArray{
            if(button == sender && index != -1){
                button.fade(to: 1, duration: 0.3)
            }else{
                button.fade(to: 0.1, duration: 0.3)
            }
        }
        
        active = index!;
    }

    func setFrames(){
        timeView.frame = textField.frame;
        promoteView.frame = textField.frame;
        anonymousView.frame = textField.frame;
        gifView.frame = textField.frame;
        locationView.frame = textField.frame;
    }
    func reset(){
        profilePic.layer.cornerRadius = profilePic.frame.height/2;
        profilePic.layer.masksToBounds = true;
        profilePic.clipsToBounds = true;
        self.textField.text = "";
        self.textField.delegate = self;
        //self.timeSlider.value = self.timeSlider.minimumValue;
        //self.sponsoredSwitch.isOn = false;
        //self.anonSwitch.isOn = false;
        self.cancelButton.enable();
        self.postButton.enable();
        self.textField.enable();
        self.textField.resignFirstResponder();
        //self.timeSlider.enable();
        //self.anonSwitch.enable();
        //self.sponsoredSwitch.enable();*/
        generateTotalCost();
        self.view.frame = CGRect(x: 0, y: -self.view.frame.height-100, width: self.parentVC!.view.frame.width, height: self.view.frame.height)
        
        setFrames();
        
        viewArray = [locationView, gifView, anonymousView, promoteView, timeView]
        buttonArray = [locButon, gifButton, anonButton, sponsorButton, timeButton]
        
        for view in viewArray{
            view.alpha = 0;
            view.isUserInteractionEnabled = false;
        }
        
        for button in buttonArray{
            button.alpha = 0.1;
        }

        textField.alpha = 1;
        
        self.view.addSubview(timeView);
        self.view.addSubview(promoteView);
        self.view.addSubview(anonymousView);
        self.view.addSubview(gifView);
        self.view.addSubview(locationView);
    }
    
    func generateTotalCost(){
        cost = 0;
        /*if(sponsoredSwitch.isOn){
            cost = cost+promoteCost;
        }
        if(anonSwitch.isOn){
            cost = cost+anonCost;
        }*/
        cost = cost+timeCost
        
        //totalCost.text = String(cost)
        
        //totalCost.frame = CGRect(x: yarnTotalCostReference.frame.maxX+2, y: totalCost.frame.minY, width: totalCost.intrinsicContentSize.width, height: totalCost.frame.height)
        
        //centerPriceView.frame = CGRect(x: 0, y: centerPriceView.frame.minY, width: totalCost.frame.maxX-yarnTotalCostReference.frame.minX, height: centerPriceView.frame.height)

        
        //centerPriceView.center = CGPoint(x: buttonView.bounds.midX, y: centerPriceView.center.y);
    }
    
    @IBAction func promoteChange(_ sender: Any) {
        generateTotalCost()
    }
    
    @IBAction func anonymousChange(_ sender: Any) {
        generateTotalCost()
    }
    func close(){
        print("Close");
        let parent = self.parentVC!.parentVC!.parent as! GlobalBoopNavigation;
        parent.replyButton.alpha = 1;
        parent.replyButton.isUserInteractionEnabled = true;
        parent.profileButton.alpha = 1;
        parent.profileButton.isUserInteractionEnabled = true;
        parent.composeButton.isUserInteractionEnabled = true;
        
        NotificationCenter.default.removeObserver(keyboardAppearObserver);
        NotificationCenter.default.removeObserver(keyboardDisappearObserver);
        
        self.textField.resignFirstResponder();
        
        self.view.layoutIfNeeded()
        self.view.layer.needsDisplayOnBoundsChange = true;
        self.view.clipsToBounds = true;
        self.view.contentMode = UIViewContentMode.redraw;
        
        self.parentVC!.interestCollectionView.fadeIn();
        self.parentVC!.messageTable.fadeIn();

        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: self.view.frame.minX, y: -self.view.frame.height-100, width: self.view.frame.width, height: self.view.frame.height/2);
        }, completion: {completed in
            print("Animation complete");
            self.reset();
            self.parentVC!.exitComposer();
        })
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        print("Composer Cancel");
        self.close();
    }
    
    @IBAction func slideChange(_ sender: Any) {
        let value = Int(timeSlider.value);
        timeCost = (value-10)*50
        timeTotal.text = String(value)+"s";
        timeLabel.text = String(timeCost);
        
        promoteCost = 1000*value;
        promoteLabel.text = String(promoteCost)
        generateTotalCost()
    }
    
    convenience init(){
        self.init(nibName: "Composer", bundle: Bundle.main)
    }
    
    convenience init(replyTo: Message){
        self.init(nibName: "Composer", bundle: Bundle.main)
        self.replyingTo = replyTo;
    }
    
    convenience init(parent: HomeController){
        self.init(nibName: "Composer", bundle: Bundle.main);
        self.parentVC = parent;
    }

    override func viewDidAppear(_ animated: Bool) {
        self.textField.placeholder = "What's on your mind kiddo?";
        print("Comp VDA")
        
        replyView.frame = CGRect(x: 0, y: 0, width: replyView.frame.width, height: replyText.frame.maxY+15);
        
        
        if(replyingTo == nil){
            //This is a new composition.
            replyView.removeFromSuperview();
        }else{
            //WE REPLYIN BOY
            for button in buttonArray{
                button.removeFromSuperview();
            }
        }
        self.reset();
    }
    
    override func viewDidLayoutSubviews() {
        interestView.populate();
        //interestView.contentOffset = CGPoint(x:-5, y:0);
    }
    
    override func viewDidLoad() {
        self.reset();
    }
    
    func animateDown(){
        print("AnimateDown");
        
        let parent = self.parentVC!.parentVC!.parent as! GlobalBoopNavigation;
        parent.replyButton.fadeOut()
        parent.replyButton.isUserInteractionEnabled = false;
        parent.profileButton.fadeOut()
        parent.profileButton.isUserInteractionEnabled = false;
        parent.composeButton.isUserInteractionEnabled = false;
        
        self.parentVC!.interestCollectionView.fadeOut();
        self.parentVC!.messageTable.fadeOut();
        
        keyboardAppearObserver = NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: {notification in
            print("Run Appear Notification")
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardRectangle.minY-parent.containerView.frame.minY)
                }, completion: {completed in
                })
            }
        })
        
        keyboardDisappearObserver = NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: {notification in
            print("Run Disappear Notification")
            let guessHeight = self.parentVC!.view.frame.maxY-self.textButton.frame.height-self.interestView.frame.height-self.textField.frame.minY-30;
            self.textField.frame = CGRect(x: self.textField.frame.minX, y: self.textField.frame.minY, width: self.textField.frame.width, height: guessHeight)
            self.setFrames();
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.parentVC!.view.frame.height)
            }, completion: {completed in
            })
        })
        
        
        self.textField.becomeFirstResponder();
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        print("KeyboardWillShow");
        
    }
}
