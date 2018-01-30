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
class Composer: UIViewController, UITextViewDelegate {
    
    @IBOutlet var promoteLabel: UILabel!
        
    @IBOutlet var yarnCount: UILabel!
    
    @IBOutlet var charRemaining: UILabel!
    
    @IBOutlet var timeTotal: UILabel!
    
    @IBOutlet var textField: UITextView!
    
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var timeSlider: UISlider!
    
    @IBOutlet var sponsoredSwitch: UISwitch!
    
    @IBOutlet var anonSwitch: UISwitch!
    
    @IBOutlet var interestView: InterestCollectionView!;
    var cost: Int = 0;
    var timeCost: Int = 0;
    var promoteCost: Int = 0;
    var anonCost: Int = 50;
    var observer: Any? = nil;
    var parentVC: HomeController? = nil;
    
    @IBOutlet var cancelButton: UIButton!

    @IBAction func sendMessage(_ sender: Any) {
        self.cancelButton.disable();
        self.postButton.disable();
        self.textField.disable();
        self.timeSlider.disable();
        self.anonSwitch.disable();
        self.sponsoredSwitch.disable();
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
            self.timeSlider.enable();
            self.anonSwitch.enable();
            self.sponsoredSwitch.enable();
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
        self.close();
    }
    
    func reset(){
        self.textField.text = "";
        self.textField.delegate = self;
        self.timeSlider.value = self.timeSlider.minimumValue;
        self.sponsoredSwitch.isOn = false;
        self.anonSwitch.isOn = false;
        self.cancelButton.enable();
        self.postButton.enable();
        self.textField.enable();
        self.textField.resignFirstResponder();
        self.timeSlider.enable();
        self.anonSwitch.enable();
        self.sponsoredSwitch.enable();
        generateTotalCost();
        self.view.frame = CGRect(x: 0, y: -self.view.frame.height-100, width: self.parentVC!.view.frame.width, height: self.view.frame.height)
    }
    
    func generateTotalCost(){
        cost = 0;
        if(sponsoredSwitch.isOn){
            cost = cost+promoteCost;
        }
        if(anonSwitch.isOn){
            cost = cost+anonCost;
        }
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
        NotificationCenter.default.removeObserver(observer!);
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height);
        }, completion: {completed in
            self.reset();
        })
        self.parentVC!.exitComposer();
    }
    @IBAction func cancelButton(_ sender: Any) {
        print("Composer Cancel");
        close();
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
    
    convenience init(parent: HomeController){
        self.init(nibName: "Composer", bundle: Bundle.main);
        self.parentVC = parent;
    }

    override func viewDidAppear(_ animated: Bool) {
        self.textField.placeholder = "What's on your mind kiddo?";
        print("Comp VDA")
        self.reset();
    }
    
    override func viewDidLayoutSubviews() {
        interestView.contentOffset = CGPoint(x: 5, y:0);
    }
    
    override func viewDidLoad() {
        self.reset();
    }
    
    func animateDown(){
        observer = NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        print("Composer AnimateDown");
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        }, completion: {completed in })
        
        
        self.textField.becomeFirstResponder();
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            print(keyboardRectangle.minY)
            let realPos = self.view.superview!.convert(self.view.frame.origin, to: nil);
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardRectangle.minY-realPos.y)
            
        }
    }
}
