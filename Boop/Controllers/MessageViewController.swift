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
    @IBOutlet var message: UITextView!;
    @IBOutlet var box: UIView!
    @IBOutlet var timerBox: UIView!
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
        self.box.layer.opacity = 0.8
        generator.impactOccurred()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.box.layer.opacity = 1
        generator.impactOccurred()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Dunno why this is overwritten
        self.view.frame = realFrame!;
        
        let frame = CGRect(x: 0, y: 0, width: timerBox.frame.width, height: timerBox.frame.height);
        timerView = BAFluidView(frame: frame, maxAmplitude: 5, minAmplitude: 2, amplitudeIncrement: 5, startElevation: 0.95)
        timerView?.fillColor = UIColor(red: 63/255, green: 194/255, blue: 101/255, alpha: 1)
        timerView?.strokeColor = UIColor.clear;
        timerView?.fillDuration = 25.0;
        timerView?.fill(to: -5);
        timerView?.fillAutoReverse = false;
        timerView?.startAnimation()
        timerView?.sizeToFit()
        timerBox.addSubview(timerView!);
        
        Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(changeToOrange), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(changeToRed), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(kill), userInfo: nil, repeats: false)
    }
    
    @objc func changeToOrange(){
        timerView?.fillColor = UIColor(red: 225/255, green: 166/255, blue: 13/255, alpha: 1)
    }
    
    @objc func changeToRed(){
        timerView?.fillColor = UIColor(red: 194/255, green: 63/255, blue: 63/255, alpha: 1)
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
        
        message.isScrollEnabled = false;
        message.sizeToFit()
        box.layer.shadowOffset =  CGSize(width: 0, height: 1)
        box.layer.shadowColor = UIColor.gray.cgColor
        box.layer.shadowRadius = 0.5
        box.layer.shadowOpacity = 0.1
        box.clipsToBounds = false;
        box.layer.masksToBounds = false;
        var finalBoxHeight = (message.frame.maxY-box.frame.minY)+15;
        box.frame = CGRect(x: box.frame.minX, y: box.frame.minY, width: box.frame.width, height: finalBoxHeight)
        timerBox.frame = CGRect(x: timerBox.frame.minX, y: timerBox.frame.minY, width: timerBox.frame.width, height: finalBoxHeight)
        timerBox.roundCorners([.topRight, .bottomRight], radius: 10)
        var frame = CGRect(x: 0, y: box.frame.minY-15, width: box.frame.width, height: finalBoxHeight+15);
        realFrame = frame;
        self.view.frame = frame;
        box.isUserInteractionEnabled = false;
    }
    
    func getHeight() -> CGFloat{
        return realFrame!.height;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
