//
//  AuthenticationSingularity.swift
//  Boop
//
//  Created by Sam Gehly on 1/13/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import BAFluidView
class AuthenticationSingularity: UIViewController{

    var fluidView: BAFluidView?;
    
    override func viewDidLoad() {
        fluidView = BAFluidView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), maxAmplitude: 20, minAmplitude: 10, amplitudeIncrement: 10, startElevation: 0.8)
        fluidView!.fillColor = greenColor;
        fluidView!.strokeColor = UIColor.clear;
        fluidView!.fillAutoReverse = false;
        fluidView!.fillRepeatCount = 1;
        fluidView!.keepStationary();
        fluidView!.startAnimation()
        fluidView!.sizeToFit()
        self.view.addSubview(fluidView!);
        self.view.sendSubview(toBack: fluidView!)
        
        let sam = User(displayName: "Sam", phoneNumber: nil, uuid: nil, accessToken: nil);
        
        let brandon = User(displayName: "Brandon", phoneNumber: nil, uuid: nil, accessToken: nil);
        
    }
    func changeToGreen(){
        self.fluidView!.fillColor = greenColor;
        self.fluidView!.fill(to: 0.8);
    }
    func changeToOrange(){
        self.fluidView!.fillColor = orangeColor;
        self.fluidView!.fill(to: 0.6);
    }
    func changeToRed(){
        self.fluidView!.fillColor = redColor;
        self.fluidView!.fill(to: 0.2);
    }
}
