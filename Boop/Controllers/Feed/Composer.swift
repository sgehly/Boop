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
class Composer: UIViewController {
    
    var cost: Int = 0;
    var timeCost: Int = 0;
    var promoteCost: Int = 0;
    var anonCost: Int = 50;
    
    @IBOutlet var cancelButton: UIButton!
    
    func generateTotalCost(){
        cost = 0;
        if(sponsoredSwitch.isOn){
            cost = cost+promoteCost;
        }
        if(anonSwitch.isOn){
            cost = cost+anonCost;
        }
        cost = cost+timeCost
        
        totalCost.text = String(cost)
        
        totalCost.frame = CGRect(x: yarnTotalCostReference.frame.maxX+2, y: totalCost.frame.minY, width: totalCost.intrinsicContentSize.width, height: totalCost.frame.height)
        
        centerPriceView.frame = CGRect(x: 0, y: centerPriceView.frame.minY, width: totalCost.frame.maxX-yarnTotalCostReference.frame.minX, height: centerPriceView.frame.height)

        
        centerPriceView.center = CGPoint(x: buttonView.bounds.midX, y: centerPriceView.center.y);
    }
    
    @IBAction func promoteChange(_ sender: Any) {
        generateTotalCost()
    }
    
    @IBAction func anonymousChange(_ sender: Any) {
        generateTotalCost()
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.textField.placeholder = "What's on your mind kiddo?"
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white;
        self.view.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardRectangle.minY)
            self.buttonView.frame = CGRect(x: self.buttonView.frame.minX, y: keyboardRectangle.minY-self.buttonView.frame.height-15, width: self.buttonView.frame.width, height: self.buttonView.frame.height)
            self.cancelButton.frame = CGRect(x: self.cancelButton.frame.minX, y: self.buttonView.frame.minY, width: self.cancelButton.frame.width, height: self.cancelButton.frame.height)
            self.settingView.frame = CGRect(x: self.settingView.frame.minX, y: self.buttonView.frame.minY-self.settingView.frame.height-15, width: self.settingView.frame.width, height: self.settingView.frame.height)
            self.categoryView.frame = CGRect(x: self.categoryView.frame.minX, y: self.settingView.frame.minY-self.categoryView.frame.height-15, width: self.categoryView.frame.width, height: self.categoryView.frame.height)
            self.textField.frame = CGRect(x: self.textField.frame.minX, y: self.textField.frame.minY, width: self.textField.frame.width, height: self.categoryView.frame.minY-15-self.textField.frame.minY)
        }
    }
    
    @IBOutlet var yarnTotalCostReference: UIImageView!
    @IBOutlet var centerPriceView: UIView!

    @IBOutlet var promoteLabel: UILabel!
    
    @IBOutlet var totalCost: UILabel!
    
    @IBOutlet var categoryView: UIView!
    @IBOutlet var settingView: UIView!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var yarnCount: UILabel!
    
    @IBOutlet var charRemaining: UILabel!
    
    @IBOutlet var timeTotal: UILabel!
    
    @IBOutlet var textField: UITextView!
    
    @IBOutlet var sendText: UILabel!
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var timeSlider: UISlider!
    
    @IBOutlet var sponsoredSwitch: UISwitch!
    
    @IBOutlet var anonSwitch: UISwitch!
}
