//
//  RegistrationController.swift
//  Boop
//
//  Created by Sam Gehly on 11/17/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import UIKit
import MRCountryPicker
import PhoneNumberKit

class RegistrationController: UIViewController, MRCountryPickerDelegate {
    
    @IBOutlet var phoneNumber: PhoneNumberTextField!
    @IBOutlet var countryImg: UIImageView!
    @IBOutlet var phoneSelectView: UIView!
    @IBOutlet var countryPicker: MRCountryPicker!
    @IBOutlet var countryButton: UIButton!
    var phoneCode: String = "+1";
    
    let formatter = PartialFormatter(phoneNumberKit: PhoneNumberKit(), defaultRegion: "US", withPrefix: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        
        // set country by its code
        countryPicker.setCountry("US")
        phoneNumber.maxDigits = 10;
    }
    
    @IBAction func editingChanged(_ sender: PhoneNumberTextField) {
        sender.text = formatter.formatPartial(sender.text!);
    }

    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.countryImg.image = flag;
        self.phoneNumber.defaultRegion = countryCode;
        self.countryButton.setTitle(phoneCode, for: UIControlState.normal)
        
        self.phoneCode = phoneCode;
        
        if(countryCode == "US"){
            self.phoneNumber.maxDigits = 10;
        }else{
            self.phoneNumber.maxDigits = 16;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendLogin(_ sender: UIButton) {
        print("Sending to Login");
        self.routeTo(identifier: "login");
    }
    
    @IBAction func selectPhoneCountry(_ sender: Any) {
        print("Attempting to select phone country");
        phoneNumber.endEditing(true);
        self.view.bringSubview(toFront: phoneSelectView)
        phoneSelectView.isHidden = false;
        phoneSelectView.frame = self.view.frame;
        UIView.animate(withDuration: 0.25, animations: {
            self.phoneSelectView.alpha = 1;
        })
    }
    @IBAction func doneSelectingCountry(_ sender: Any) {
        print("Done Selecting Country");
        UIView.animate(withDuration: 0.25, animations: {
            self.phoneSelectView.alpha = 0;
        }, completion: { result -> Void in
            self.phoneSelectView.isHidden = true;
            self.view.sendSubview(toBack: self.phoneSelectView)
        })
    }
    
    @IBAction func registrationPhoneNumber(_ sender: Any) {
        
        //Skip
        //return self.navigationRouteTo(identifier: "finishSignup", controller: FinishProfileController())
        
        if(self.phoneNumber.text == ""){
            return self.showError(title: "Registration Error", message: "Please enter your phone number.");
        }
        
        postRequest(endpoint: "users/auth/checkPhone", body: ["phoneNumber": self.phoneCode+phoneNumber.nationalNumber])
        .then { response -> Void in
            if(!response["success"].boolValue){
                return self.showError(title: "Registration Error", message: response["message"].stringValue);
            }
            currentUser = User(displayName: "Simon", phoneNumber: self.phoneCode+self.phoneNumber.nationalNumber, uuid: nil, accessToken: nil);
            
            return self.navigationRouteTo(identifier: "confirmNumber", controller: ConfirmationController());
        }
        .catch { error -> Void in
            if let err = error as? BoopRequestError{
                switch err{
                case .HTTPError(let message):
                    self.showError(title: "Registration HTTP Error", message: message);
                    break;
                case .BoopError(let code, let message):
                    self.showError(title: "Registration Error "+String(code), message: message);
                    break;
                default:
                    break;
                }
            }
        }
    }
}

