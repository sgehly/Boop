//
//  InterestCollectionView.swift
//  Boop
//
//  Created by Sam Gehly on 1/7/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import SwiftyShadow

class InterestCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var interestArray: [Interest] = [];
    var cells: [UICollectionViewCell] = [];
    var views: [MiniInterestViewController] = [];
    let layout = UICollectionViewFlowLayout();
    var interestsOnly = true;
    var initialized = false;
    var totalWidth: CGFloat = 0;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout.scrollDirection = .horizontal;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        self.collectionViewLayout = layout;
        self.dataSource = self;
        self.delegate = self;
        self.layer.zPosition = 9999;
        self.isPrefetchingEnabled = true;
    }
    func populate(){
        print("Populating");
        self.initialized = true;
        
        self.interestArray = [];
        
        if(!interestsOnly){
            self.interestArray.append(Interest(name: "Feed", color: boopColor, order: 0))
            self.interestArray.append(Interest(name: "Global", color: boopColor, order: 1))
        }
        
        for interest in currentUser!.interests{
            self.interestArray.append(interest);
        }

        cells = Array(repeating: UICollectionViewCell(), count: self.interestArray.count)
        
        totalWidth = 0;
        for interest in interestArray {
            let interestVC = MiniInterestViewController(interest: interest)
            totalWidth = totalWidth+interestVC.view.frame.width;
            views.append(interestVC)
        }
        
        self.contentSize = CGSize(width: totalWidth, height: self.contentSize.height)
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "miniInterest")
        self.reloadData();
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return views[indexPath.item].view.frame.size;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(!initialized){
            return 0;
        }
        return interestArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "miniInterest", for: indexPath)
 
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview();
        }
        
        cell.contentView.addSubview(views[indexPath.item].view)
        cells[indexPath.item] = cell;
        
        views[indexPath.item].view.setNeedsLayout();
        
        
        return cell;
    }
    
    func redraw(){
        for VC in views{
            VC.view.draw(VC.view.frame);
        }
    }
    
}

class MiniInterestViewController: UIViewController{
    @IBOutlet var interestLabel: UILabel!
    var realFrame: CGRect? = nil;
    var interest: Interest? = nil;
    
    override func viewDidLayoutSubviews() {
        self.view.frame = realFrame!;
        self.view.layer.cornerRadius = realFrame!.height/2;

    }
    override func viewDidLoad(){
        interestLabel.text = interest!.name;
        interestLabel.textAlignment = .center
        interestLabel.frame = self.view.frame;
        interestLabel.center = self.view.center;
        //self.view.layer.borderColor = interest!.color.cgColor;
        //self.view.layer.borderWidth = 2;
        self.view.backgroundColor = UIColor.white;
        self.view.layer.masksToBounds = true;
        self.view.clipsToBounds = true;
        interestLabel.textColor = interest!.color
        
        
        self.view.frame = CGRect(x: 0, y: 0, width: interestLabel.intrinsicContentSize.width+30, height: interestLabel.intrinsicContentSize.height+10)
        
        interestLabel.center = self.view.center;
        realFrame = self.view.frame;
    }
    convenience init(interest: Interest){
        self.init(nibName: "Interest", bundle: Bundle.main);
        self.interest = interest;
    }
    
}
