//
//  Message.swift
//  Boop
//
//  Created by Sam Gehly on 1/2/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import BAFluidView

class MessageViewController: UIViewController{
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    @IBOutlet var profilePic: UIImageView!;
    @IBOutlet var displayName: UILabel!;
    @IBOutlet var locationTag: UILabel!;
    @IBOutlet var message: UILabel!;
    @IBOutlet var box: UIView!
    @IBOutlet var timerBox: UIView!
    @IBOutlet var colorBox: UIView!
    //@IBOutlet var menu: UIImageView!
    var timerView: BAFluidView? = nil;

    //Needed for removal from the table.
    var table: MessageTableView?;
    var row: Int?;
    
    //Needed for content and placement
    var reference: Message?;
    var realFrame: CGRect?;
    
    func initializeTimer(){
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.box.layer.opacity = 0.4
        generator.impactOccurred()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.box.layer.opacity = 0.4
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.box.layer.opacity = 1
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.box.layer.opacity = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Dunno why this is overwritten
        //self.view.frame = realFrame!;
        
        let duration = 10;
        timerView = BAFluidView(frame: CGRect(x: 0, y: 0, width: timerBox.frame.width, height: timerBox.frame.height), maxAmplitude: 5, minAmplitude: 2, amplitudeIncrement: 5, startElevation: 0.95)
        timerView?.fillColor = greenColor;
        timerView?.strokeColor = UIColor.clear;
        timerView?.fillDuration = CFTimeInterval(duration+(duration/4));
        timerView?.fill(to: -5);
        timerView?.fillAutoReverse = false;
        timerView?.startAnimation()
        timerView?.sizeToFit()
        timerBox.addSubview(timerView!);
        
        Timer.scheduledTimer(timeInterval: (TimeInterval(duration-(duration/2))), target: self, selector: #selector(changeToOrange), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval: (TimeInterval(duration-(duration/4))), target: self, selector: #selector(changeToRed), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(duration), target: self, selector: #selector(kill), userInfo: nil, repeats: false)
    }
    
    @objc func changeToOrange(){
        print("Change Orange")
        timerView?.fillColor = orangeColor
    }
    
    @objc func changeToRed(){
        print("Change Red")
        timerView?.fillColor = redColor
    }
    
    @objc func kill(){
        UIView.animate(withDuration: 1, animations: {
            self.box.layer.opacity = 0;
            self.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { completed in
            //If we ever want to put removeMessage() back in completion.
        })
        self.table!.removeMessage(message: self.reference!);
    }
    init(reference: Message, table: MessageTableView, row: Int){
        self.table = table;
        self.row = row;
        self.reference = reference;
        super.init(nibName: "MessageView", bundle: Bundle.main)
        self.view.backgroundColor = UIColor.clear;
        
        message.text = reference.message;
        displayName.text = reference.author.displayName;
        
        displayName.sizeToFit();
        message.sizeToFit();
        
        var finalBoxHeight = colorBox.frame.maxY+10;
        if(message.frame.maxY > finalBoxHeight){
            finalBoxHeight = message.frame.maxY+25;
        }
        
        timerBox.frame = CGRect(x: box.frame.maxX-timerBox.frame.width, y: timerBox.frame.minY, width: timerBox.frame.width, height: finalBoxHeight)
        timerBox.roundCorners([.topRight, .bottomRight], radius: 8)
        
        colorBox!.layer.cornerRadius = colorBox!.frame.height/2;
        colorBox!.clipsToBounds = true;
        colorBox!.layer.masksToBounds = true;
        
        
        var frame = CGRect(x: 0, y: box.frame.minY, width: table.frame.width, height: finalBoxHeight+15);
        realFrame = frame;
        self.view.frame = frame;
        
        timerBox.frame = CGRect(x: box.frame.maxX-timerBox.frame.width, y: timerBox.frame.minY, width: timerBox.frame.width, height: finalBoxHeight)
        
        message.frame = CGRect(x: message.frame.minX, y: message.frame.minY+10, width: timerBox.frame.minX-10-message.frame.minX, height: message.frame.height)
        
        box.frame = CGRect(x: box.frame.minX, y: box.frame.minY, width: self.view.frame.width-30, height: finalBoxHeight)

        colorBox.center = CGPoint(x: colorBox.center.x, y: box.center.y);
        
        box.center = self.view.center
        
    }
    
    func getHeight() -> CGFloat{
        return realFrame!.height;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
