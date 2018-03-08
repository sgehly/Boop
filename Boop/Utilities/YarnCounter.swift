//
//  YarnCounter.swift
//  Boop
//
//  Created by Sam Gehly on 1/15/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class YarnCounter: UIView{
    
    var iconSize: CGFloat = 30;
    var textSize: CGFloat = 15;
    
    var icon = UIImageView()
    var counter = UILabel();
    
    override func awakeFromNib() {
        iconSize = self.frame.height;
        updateSize();
    }

    func updateSize(){
        icon.image = UIImage(named: "yarn")!.resize(to: CGSize(width: iconSize, height: iconSize));
        counter.font = UIFont(name: counter.font.fontName, size: textSize);
        counter.text = String(0);
        icon.contentMode = .scaleAspectFit;
        icon.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize);
        counter.frame = CGRect(x: icon.frame.maxX+5, y: counter.frame.minY, width: counter.intrinsicContentSize.width, height: counter.intrinsicContentSize.height);
        self.frame = CGRect(x: 0, y: 0, width: counter.frame.maxY-icon.frame.minY, height: iconSize);
        
        self.addSubview(icon)
        self.addSubview(counter);
    }
    func changeCount(yarn: Int){
        counter.text = String(yarn);
        updateSize();
    }
}
