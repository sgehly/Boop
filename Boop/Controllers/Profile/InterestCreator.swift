//
//  InterestCreator.swift
//  Boop
//
//  Created by Sam Gehly on 1/7/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import IGColorPicker

class InterestCreator: UIViewController, ColorPickerViewDelegate, ColorPickerViewDelegateFlowLayout{
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var interestField: UITextField!
    @IBOutlet var labelColor: UILabel!
    var color: UIColor? = nil;
    var colorPickerView: ColorPickerView!
    var parentVC: ProfileViewController?;
    var observer: Any? = nil;
    
    init(parentVC: ProfileViewController){
        super.init(nibName: "InterestCreator", bundle: Bundle.main);
        self.parentVC = parentVC;
    }
    
    func reset(){
        print("Creator Reset");
        self.view.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.parentVC!.view.frame.width, height: self.view!.frame.height);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.cancelButton.frame = CGRect(x: self.cancelButton.frame.minX, y: self.cancelButton.frame.minY, width: self.view.frame.midX-5-self.cancelButton.frame.minX, height: self.cancelButton.frame.height);
        self.addButton.frame = CGRect(x: self.view.frame.midX+5, y: self.addButton.frame.minY, width: self.cancelButton.frame.width, height: self.addButton.frame.height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        reset();
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white;
        reset();
        self.colorPickerView = ColorPickerView(frame: CGRect(x: 0, y: labelColor.frame.maxY+5, width: self.view.frame.width, height: 100))
        self.colorPickerView.style = .circle;
        self.colorPickerView.layoutDelegate = self
        self.colorPickerView.delegate = self
        self.view.addSubview(self.colorPickerView)
    }
    
    func animateDown(){
        print("Creator AnimateDown");
        observer = NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        }, completion: {completed in })
        
        self.interestField.becomeFirstResponder();
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if(!interestField.isFirstResponder){
            return;
        }
        /*if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardRectangle.minY)
            self.addButton.frame = CGRect(x: self.addButton.frame.minX, y: keyboardRectangle.minY-self.addButton.frame.height-15, width: self.addButton.frame.width, height: self.addButton.frame.height)
            self.cancelButton.frame = CGRect(x: self.cancelButton.frame.minX, y: self.addButton.frame.minY, width: self.cancelButton.frame.width, height: self.cancelButton.frame.height)
            /*self.colorPickerView = ColorPickerView(frame: CGRect(x: cancelButton.frame.minX, y: labelColor.frame.maxY+5, width: addButton.frame.maxX-cancelButton.frame.minX, height: (cancelButton.frame.minY-10)-(labelColor.frame.maxY+5)))*/
        }*/
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            print(keyboardRectangle.minY)
            let realPos = self.view.superview!.convert(self.view.frame.origin, to: nil);
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardRectangle.minY-realPos.y)
            
        }
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20;
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20;
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        color = colorPickerView.colors[indexPath.item]
    }
    
    @IBAction func cancelInterest(_ sender: Any) {
        print("Remove Observer");
        NotificationCenter.default.removeObserver(observer!)
        interestField!.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: -self.view.frame.height-100, width: self.view.frame.width, height: self.view!.frame.height);
        }, completion: {completed in
            self.reset();
        })
        
        parentVC!.exitCreator()
    }
    
    func cancel(){
        NotificationCenter.default.removeObserver(observer!)
        interestField!.resignFirstResponder()
        self.interestField.text = "";
        self.colorPickerView.colors = self.colorPickerView.colors;
        parentVC!.exitCreator()
    }
    
    @IBAction func addInterest(_ sender: Any) {
        let trim = interestField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(trim.count < 1){
            self.showError(title: "Interest Error", message: "Please enter an interest.")
            return;
        }
        if(color == nil){
            self.showError(title: "Interest Error", message: "Please pick a color.")
            return;
        }
        
        postRequest(endpoint: "interests/create", body: [
            "name": interestField.text,
            "color": color?.hexString!
        ])
        .then{ response -> Void in
            if(response["message"]["exists"].boolValue){
                self.continuePrompt(title: self.interestField.text!, message: "This interest already exists. Do you want to join it?")
                .then{ choiceCode -> Void in
                    if(choiceCode == 0){
                        self.cancel();
                    }else{
                        currentUser!.addInterest(interest: Interest(name: self.interestField.text!, color: self.color!, order: currentUser!.interests.count+1))
                    }
                }
            }else{
                currentUser!.addInterest(interest: Interest(name: self.interestField.text!, color: self.color!, order: currentUser!.interests.count+1))
            }
        }
        .catch{ error in
                
        }
    }
    // This is an optional method
    func colorPickerView(_ colorPickerView: ColorPickerView, didDeselectItemAt indexPath: IndexPath) {
        color = boopColor;
    }
}
