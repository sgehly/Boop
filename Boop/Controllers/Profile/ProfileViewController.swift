//
//  ProfileViewController.swift
//  Boop
//
//  Created by Sam Gehly on 1/3/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import ESPullToRefresh
import UIKit

class ProfileViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UITextFieldDelegate{
    
    
    var creator: InterestCreator? = nil;
    var parentVC: BoopPageViewController? = nil;
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var gradientView: UIView!
    @IBOutlet var featuredCollectionView: InterestExploreCollectionView!
    @IBOutlet var trendingCollectionView: InterestExploreCollectionView!
    @IBOutlet var personalCollectionView: InterestExploreCollectionView!
    
    @IBOutlet var searchBar: UITextField!

    func addTapToDismiss(view: UIView){
        let scrollViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard));
        scrollViewTapGestureRecognizer.numberOfTapsRequired = 1
        scrollViewTapGestureRecognizer.isEnabled = true
        scrollViewTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(scrollViewTapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        //containerView.frame = scrollView.frame;
        featuredCollectionView.setRealWidth(realWidth: self.view.frame.width)
        trendingCollectionView.setRealWidth(realWidth: self.view.frame.width)
        personalCollectionView.setRealWidth(realWidth: self.view.frame.width)
        
        scrollView.contentOffset = CGPoint.zero;
    }
    override func viewDidLoad() {
        creator = InterestCreator(parentVC: self);
        creator!.reset();
        parentVC = self.parent as! BoopPageViewController;
        searchBar.setLeftPaddingPoints(25);
        searchBar.layer.cornerRadius = searchBar.frame.height/2;
        self.view.addSubview(creator!.view);
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.contentInset = UIEdgeInsets.zero;
        
        searchBar.delegate = self;
        scrollView.delegate = self;
        
        addTapToDismiss(view: personalCollectionView)
        addTapToDismiss(view: featuredCollectionView)
        addTapToDismiss(view: trendingCollectionView)
        
        featuredCollectionView.personalCollectionView = personalCollectionView;
        trendingCollectionView.personalCollectionView = personalCollectionView;
        featuredCollectionView.parentVC = self;
        trendingCollectionView.parentVC = self;
        featuredCollectionView.type = .exploratory
        trendingCollectionView.type = .exploratory
        personalCollectionView.type = .personal
        
        
        personalCollectionView.populate(interests: currentUser!.interests, width: self.view.frame.width);
        
        getRequest(endpoint: "interests/featured")
        .then { response -> Void in
            
            var interestArray: [Interest] = [];
            
            let array = response["message"]["interests"].arrayValue
            
            for interest in array{
                interestArray.append(Interest(name: interest["name"].stringValue, color: UIColor().HexToColor(hexString: interest["color"].stringValue), order: 0))
            }
    
            self.featuredCollectionView.populate(interests: interestArray, width: self.view.frame.width)
        }
        
        getRequest(endpoint: "interests/popular")
        .then{ response -> Void in
            
            var interestArray: [Interest] = [];
            
            let array = response["message"]["interests"].arrayValue
            
            for interest in array{
                interestArray.append(Interest(name: interest["name"].stringValue, color: UIColor().HexToColor(hexString: interest["color"].stringValue), order: 0))
            }
            
            self.trendingCollectionView.populate(interests: interestArray, width: self.view.frame.width)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        exitCreator();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    @objc func dismissKeyboard(){
        searchBar.resignFirstResponder();
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard();
    }
    
    
    func enterCreator(){
        parentVC?.dataSource = nil
        self.creator!.animateDown();
    }
    
    func exitCreator(){
        parentVC?.dataSource = parentVC
    }
    
    @IBAction func tapAdd(_ sender: UIButton) {
        enterCreator();
    }
    
}
