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
    let layout = UICollectionViewFlowLayout();
    var totalWidth: CGFloat = 0;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout.scrollDirection = .horizontal;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 15);
        self.collectionViewLayout = layout;
        self.dataSource = self;
        self.delegate = self;
        self.layer.masksToBounds = true;
        self.clipsToBounds = true;
        self.layer.cornerRadius = 10;
        self.layer.zPosition = 9999;
        self.isPrefetchingEnabled = false;
        print(currentUser!.interests)
        interestArray = currentUser!.interests;
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "interestminilmao")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row < cells.count){
            //self.frame.size = CGSize(width: self.frame.width, height: cells[indexPath.row].frame.size.height);
            
            let cell = cells[indexPath.row];
            /*if(totalWidth < self.frame.width){
                cell.frame.size = CGSize(width: self.frame.width/CGFloat(cells.count), height: cell.frame.height);
                cell.contentView.frame = cell.frame;
                for subview in cell.contentView.subviews{
                    subview.frame = cell.contentView.frame;
                }
            }*/
            print("SETTING SIZE");
            return cells[indexPath.row].frame.size;
        }else{
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Get count of", interestArray.count+2)
        return interestArray.count+2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var interest: Interest? = nil;
        
        if(indexPath.row == 0){
            interest = Interest(name: "Feed", color: boopColor, order: 0)
        }
        else if(indexPath.row == 1){
            interest = Interest(name: "All", color: boopColor, order: 1)
        }else{
            print(indexPath.row, interestArray);
            interest = interestArray[indexPath.row-2];
        }
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: "interestminilmao", for: indexPath)
        let interestVC = MiniInterestViewController(interest: interest!)
        
        if(cell.contentView.subviews.count == 0){
            cell.contentView.addSubview(interestVC.view);
            print(interestVC.view.frame, cell.contentView.frame, cell.frame)
            
            cell.contentView.frame = interestVC.view.frame;
            cell.frame = cell.contentView.frame;
            //cell.frame = cell.contentView.frame
            totalWidth = totalWidth+cell.frame.width;
            cells.append(cell);
            layout.invalidateLayout()
        }

        return cell;
    }
    
}

class MiniInterestViewController: UIViewController{
    @IBOutlet var interestLabel: UILabel!
    @IBOutlet var colorTab: UIView!
    @IBOutlet var bottomColorTab: UIView!
    var realFrame: CGRect? = nil;
    var interest: Interest? = nil;
    
    override func viewDidLayoutSubviews() {
        /*self.view.frame = CGRect(x: 0, y: 0, width: interestLabel.intrinsicContentSize.width+30, height: interestLabel.intrinsicContentSize.height+10)
        interestLabel.center = self.view.center;
        print(self.view.frame);*/
        print("VDLS NOTIFICATION");
        self.view.frame = realFrame!;
        self.view.layer.cornerRadius = realFrame!.height/2;

    }
    override func viewDidLoad(){
        interestLabel.text = interest?.name;
        interestLabel.textAlignment = .center
        interestLabel.frame = self.view.frame;
        interestLabel.center = self.view.center;
        self.view.layer.borderColor = interest?.color.cgColor;
        self.view.layer.borderWidth = 2;
        self.view.layer.masksToBounds = true;
        self.view.clipsToBounds = true;
        interestLabel.textColor = interest?.color
        
        
        self.view.frame = CGRect(x: colorTab.frame.minX, y: colorTab.frame.minY, width: interestLabel.intrinsicContentSize.width+30, height: interestLabel.intrinsicContentSize.height+10)
        interestLabel.center = self.view.center;
        realFrame = self.view.frame;
        print(self.view.frame);
    }
    convenience init(interest: Interest){
        self.init(nibName: "Interest", bundle: Bundle.main);
        self.interest = interest;
    }
    
}
