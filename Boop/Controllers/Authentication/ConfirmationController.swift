
//
//  ConfirmationController.swift
//  Boop
//
//  Created by Sam Gehly on 11/29/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import UIKit
import KeychainAccess

class ConfirmationController: UIViewController, UITextFieldDelegate {

    @IBOutlet var char1: UITextField!
    @IBOutlet var char2: UITextField!
    @IBOutlet var char3: UITextField!
    @IBOutlet var char4: UITextField!
    @IBOutlet var char5: UITextField!
    
    var textFieldArray: [UITextField] = [];
    var first = false
    
    var attemptCount = 0;
    
    func addBottomBorder(view: UIView!){
        print(view);
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: view!.frame.height - 1, width: view!.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor;
        view.layer.addSublayer(bottomLine)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldArray = [char1, char2, char3, char4, char5];
        
        for (index, textField) in textFieldArray.enumerated() {
            addBottomBorder(view: textField);
            textField.tag = index;
            textField.delegate = self;
            textField.backgroundColor = UIColor.white;
        }
        
        char1.becomeFirstResponder();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "\u{200B}"
    }
    
    func clearAllFields(){
        for (index, textField) in self.textFieldArray.enumerated() {
            textField.text = "";
        }
        self.textFieldArray[0].becomeFirstResponder();
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Called delegate");
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (string == "") {
            print("Backspace was pressed")
            
            var tag = textField.tag-1;
            if(textField.tag == 0){
                tag = 0;
            }
            textFieldArray[tag].text = "";
            textFieldArray[tag].becomeFirstResponder();
            return false;
        }
        
         textFieldArray[textField.tag].text = string;
        
        if(textField.tag == textFieldArray.count-1){
            //Continue.
            print("Continue on")
            var generatedCode = "";
            for textField in textFieldArray{
                generatedCode += textField.text!;
            }
            postRequest(endpoint: "users/auth/verify", body: ["code": generatedCode])
            .then { response -> Void in
                if(response["message"]["loginUser"].boolValue){
                    setLogin(uuid: response["message"]["data"]["uuid"].stringValue, token: response["message"]["data"]["accessToken"].stringValue)
                    self.navigationController?.dismiss(animated: true, completion: {
                        self.routeTo(identifier: "boopNavigation");
                    })
                }else{
                    self.navigationRouteTo(identifier: "finishSignup", controller: FinishProfileController())
                }
            }
            .catch { error -> Void in
                self.clearAllFields();
                if let err = error as? BoopRequestError{
                    switch err{
                    case .HTTPError(let message):
                        self.showError(title: "Confirmation HTTP Error", message: message);
                        break;
                    case .BoopError(let code, let message):
                        if(code == 401){
                            self.clearAllFields()
                            if(self.attemptCount < 2){
                                self.attemptCount = self.attemptCount+1;
                                self.showError(title: "Incorrect Code", message: "Please try again.");
                            }else{
                                self.prompt(title: "Incorrect Code", message: "Please re-enter your phone number and try again.")
                                    .then { response in
                                        self.navigationRouteBack();
                                }
                            }
                        }
                        self.showError(title: "Registration Error "+String(code), message: message);
                    }
                }
            }
        }else{
            print("Move Forward")
            textFieldArray[textField.tag+1].becomeFirstResponder();
        }
        
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationRouteBack();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
