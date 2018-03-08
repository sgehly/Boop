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
    var layout: ExploreLayout? = nil;
    var totalWidth: CGFloat = 0;
    
    var cellSize: CGSize = CGSize(width:0, height:0);
    var cellWidth: CGFloat = 0;
    
    var cellCount = 6;
    var widthCount = 3;
    
    var personalCollectionView: InterestExploreCollectionView? = nil;
    var parentVC: ProfileViewController? = nil;
    
    var light = UIImpactFeedbackGenerator(style: .light)
    var heavy = UIImpactFeedbackGenerator(style: .heavy)
    
    var type: ExploreType = .exploratory;
    
    func setRealWidth(realWidth: CGFloat) {
        layout = ExploreLayout(size: CGSize(width: realWidth, height: self.frame.height));
        layout!.scrollDirection = .horizontal;
        layout!.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout!.minimumLineSpacing = 10;
        layout!.minimumInteritemSpacing = 10;
        self.collectionViewLayout = layout!;
        self.layout!.invalidateLayout();
        self.reloadData();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        print("Creating layout with width of", self.frame.width);
        self.dataSource = self;
        self.delegate = self;
        self.layer.masksToBounds = true;
        self.clipsToBounds = true;
        self.layer.zPosition = 9999;
        self.isPrefetchingEnabled = false;
        self.isPagingEnabled = true;
        self.isScrollEnabled = true;
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "interestExplore")
    }
    
    func populate(interests: [Interest], width: CGFloat){
        self.interestArray = interests;
        
        if(self.layout != nil){
            self.layout!.invalidateLayout();
        }
        
        self.reloadData();
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = Int(CGFloat(interestArray.count/cellCount).rounded(.up))+1;
        return count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if((indexPath.section*cellCount)+indexPath.row > interestArray.count){
            return
        }
        var interest: Interest =
            interestArray[(indexPath.section*cellCount)+indexPath.row];
        
        if(currentUser!.interests.index(of: interest) != nil){
            light.impactOccurred();
            return;
        }
        
        self.parentVC!.continuePrompt(title: "Add Interest?", message: interest.name+" will be added to your interests and home feed.")
        .then{ response -> Void in
            if(response == 0){
                return;
            }
            self.heavy.impactOccurred();
            self.heavy.impactOccurred();
            currentUser!.addInterest(interest: interest);
            self.parentVC?.featuredCollectionView.reloadData();
            self.parentVC?.trendingCollectionView.reloadData();
            self.personalCollectionView!.populate(interests: currentUser!.interests, width: self.frame.width);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print(interestArray[(indexPath.section*3)+indexPath.row].name, (indexPath.section*3), indexPath.row)
        print("CFIA");
        let cell = self.dequeueReusableCell(withReuseIdentifier: "interestExplore", for: indexPath)
        
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview();
        }
        
        let remaining = cellCount-(cells.count%cellCount);
        let path = (indexPath.section*cellCount)+indexPath.row;
        
        if(path >= interestArray.count){
            return cell;
        }
        
        var interest: Interest = interestArray[path];
        
        let interestVC = InterestExploreViewController(interest: interest, size: cellSize, type: type)
         
        cell.contentView.addSubview(interestVC.view);
        
        interestVC.view.frame = cell.contentView.frame;
        
        if(cells.index(of: cell) == nil){
            cells.append(cell);
        }
        
        self.layout!.invalidateLayout();
        return cell;
    }
    
}

enum ExploreType {
    case personal
    case exploratory
}

class InterestExploreViewController: UIViewController{
    @IBOutlet var interestLabel: UILabel!
    @IBOutlet var box: UIView!;
    @IBOutlet var circle: UIView!;
    @IBOutlet var icon: UILabel!;
    
    @IBOutlet var circleContainer: UIView!
    
    @IBOutlet var centerView: UIView!
    @IBOutlet var memberCount: UILabel!
    @IBOutlet var memberImage: UIImageView!
    
    var realFrame: CGRect? = nil;
    var interest: Interest? = nil;
    var size: CGSize = CGSize(width:0, height:0);
    var type: ExploreType = .exploratory;
    
    override func viewDidLayoutSubviews() {
        
        circleContainer.clipsToBounds = true;
        circleContainer.layer.masksToBounds = true;
        circleContainer.layer.cornerRadius = 8;
        
        circle.backgroundColor = interest!.color;
        circle.clipsToBounds = true;
        circle.layer.masksToBounds = true;
        circle.layer.cornerRadius = 8
        circle.frame = CGRect(x: 0, y: 0, width: circleContainer.frame.width, height: circleContainer.frame.height)
        circle.setNeedsDisplay();
        
        let maskPath = UIBezierPath(roundedRect: circle.bounds,
                                    byRoundingCorners: [.bottomRight, .bottomLeft],
                                    cornerRadii: CGSize(width: circle.bounds.width/2, height: circle.bounds.width/2))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        circle.layer.mask = maskLayer
        circle.setNeedsDisplay();
    }
    override func viewDidLoad(){
        interestLabel.text = interest?.name;
        interestLabel.textAlignment = .center
        
        box.layer.cornerRadius = 8
        box.layer.masksToBounds = true;
        box.clipsToBounds = true;
        
        
        
        if(currentUser!.interests.index(of: interest!) != nil && type != .personal){
            self.view.alpha = 0.4;
        }

        interestLabel.font = interestLabel.font.withSize(24);
        
        
        memberCount.text = String(128);
        memberCount.frame = CGRect(x: memberCount.frame.minX, y: memberCount.frame.minY, width: memberCount.intrinsicContentSize.width, height: memberCount.intrinsicContentSize.height);
        
        centerView.frame = CGRect(x: 0, y: centerView.frame.minY, width: memberCount.frame.width+memberImage.frame.width, height: memberCount.frame.height);
        
    }
    convenience init(interest: Interest, size: CGSize, type: ExploreType){
        self.init(nibName: "InterestExplore", bundle: Bundle.main);
        self.interest = interest;
        self.size = size;
        self.type = type;
    }
    
}

