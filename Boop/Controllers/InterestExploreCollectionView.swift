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

class InterestExploreCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var interestArray: [Interest] = [];
    var cells: [UICollectionViewCell] = [];
    let layout = UICollectionViewFlowLayout();
    var totalWidth: CGFloat = 0;
    
    var cellSize: CGSize = CGSize(width:0, height:0);
    var cellWidth: CGFloat = 0;
    
    var cellCount = 6;
    var widthCount = 3;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        layout.scrollDirection = .horizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        self.collectionViewLayout = layout;
        self.dataSource = self;
        self.delegate = self;
        self.layer.masksToBounds = true;
        self.clipsToBounds = true;
        self.layer.cornerRadius = 10;
        self.layer.zPosition = 9999;
        self.isPrefetchingEnabled = false;
        self.isPagingEnabled = true;
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "interestExplore")
    }
    func populate(interests: [Interest]){
        self.interestArray = interests;
        cellWidth = (self.frame.width-50)/CGFloat(widthCount);
        print(cellWidth);
        cellSize = CGSize(width: cellWidth, height: (self.frame.height/2)-10);
        self.reloadData();
        self.layout.invalidateLayout();
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = Int(CGFloat(interestArray.count/cellCount).rounded(.up))+1;
        return count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*let totalRemaining = interestArray.count-(section*cellCount);
        print(totalRemaining);
        if(totalRemaining < cellCount){
            return totalRemaining;
        }*/
        return cellCount;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print(interestArray[(indexPath.section*3)+indexPath.row].name, (indexPath.section*3), indexPath.row)
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: "interestExplore", for: indexPath)
        
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview();
        }
        
        if(cells.count < cellCount){
            //We gotta do a funky layout thing.
            let remaining = cellCount-(cells.count%cellCount);
        }
        
        if((indexPath.section*cellCount)+indexPath.row >= interestArray.count){
            return cell;
        }
        
        var interest: Interest = interestArray[(indexPath.section*cellCount)+indexPath.row];
        
        print(interest.name)
        let interestVC = InterestExploreViewController(interest: interest, size: cellSize)
        
        cell.contentView.addSubview(interestVC.view);
        interestVC.view.frame = cell.contentView.frame;
        
        if(cells.index(of: cell) == nil){
            cells.append(cell);
        }
        
        return cell;
    }
    
}

class InterestExploreViewController: UIViewController{
    @IBOutlet var interestLabel: UILabel!
    //@IBOutlet var colorTab: UIView!
    //@IBOutlet var bottomColorTab: UIView!
    var realFrame: CGRect? = nil;
    var interest: Interest? = nil;
    var size: CGSize = CGSize(width:0, height:0);
    
    override func viewDidLayoutSubviews() {
        /*self.view.frame = CGRect(x: 0, y: 0, width: interestLabel.intrinsicContentSize.width+30, height: interestLabel.intrinsicContentSize.height+10)
         interestLabel.center = self.view.center;
         print(self.view.frame);*/
        //print("VDLS NOTIFICATION");
        //self.view.frame = realFrame!;
        
    }
    override func viewDidLoad(){
        interestLabel.text = interest?.name;
        interestLabel.textAlignment = .center
        interestLabel.frame = self.view.frame;
        interestLabel.center = self.view.center;
        self.view.layer.cornerRadius = 15
        self.view.backgroundColor = interest?.color;
        self.view.layer.masksToBounds = true;
        self.view.clipsToBounds = true;
        
        
        //self.view.frame = CGRect(x: colorTab.frame.minX, y: colorTab.frame.minY, width: interestLabel.intrinsicContentSize.width+30, height: interestLabel.intrinsicContentSize.height+10)
        interestLabel.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY-(interestLabel.frame.height/2)-10)
        interestLabel.font = interestLabel.font.withSize(12);
        self.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    convenience init(interest: Interest, size: CGSize){
        self.init(nibName: "InterestExplore", bundle: Bundle.main);
        self.interest = interest;
        self.size = size;
    }
    
}

