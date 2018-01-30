//
//  YarnCounter.swift
//  Boop
//
//  Created by Sam Gehly on 1/15/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class YarnCounter: UIViewController{
    
    @IBOutlet var counter: UILabel!;
    @IBOutlet var icon: UIImageView!;
    @IBOutlet var container: UIView!
    
    var iconSize: CGFloat = 30;
    var textSize: CGFloat = 15;
    
    override func viewDidLayoutSubviews() {
        iconSize = self.view.frame.height;
        updateSize();
    }
    override func viewDidAppear(_ animated: Bool) {
        print("DA", self.view.frame)
    }
    override func awakeFromNib() {
        print("NIB", self.view.frame);
    }
    func updateSize(){
        icon.image = icon.image!.resize(to: CGSize(width: iconSize, height: iconSize));
        counter.font = UIFont(name: counter.font.fontName, size: textSize);
        icon.contentMode = .scaleAspectFit;
        icon.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize);
        counter.frame = CGRect(x: icon.frame.maxX+5, y: counter.frame.minY, width: counter.intrinsicContentSize.width, height: counter.intrinsicContentSize.height);
        container.frame = CGRect(x: 0, y: 0, width: iconSize+5+counter.frame.width, height: iconSize);
        
        counter.center = CGPoint(x: counter.center.x, y: container.center.y)
        container.center = CGPoint(x: self.view.center.x, y: container.center.y)
    }
    func changeCount(yarn: Int){
        counter.text = String(yarn);
        updateSize();
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(nibName: "YarnCount", bundle: Bundle.main)
        self.view.backgroundColor = UIColor.clear;
    }
}
