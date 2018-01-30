//
//  HomeController.swift
//  Boop
//
//  Created by Sam Gehly on 11/28/17.
//  Copyright © 2017 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit
import BAFluidView

class HomeController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet var header: UIView!
    @IBOutlet var messageTable: MessageTableView!
    var profileShouldComplete = false;
    var composer: Composer? = nil;
    var parentVC: BoopPageViewController? = nil;
    var observer: Any? = nil;
    
    var generator = UIImpactFeedbackGenerator(style: .heavy)
    
    @IBOutlet var gradientContainer: UIView!
    @IBOutlet var interestShadowView: UIView!
    @IBOutlet var noMessageView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        composer!.reset();
    }
    
    @IBOutlet var interestCollectionView: InterestCollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad();
        messageTable.noView = noMessageView;
        self.parentVC = self.parent as? BoopPageViewController
        self.view.isUserInteractionEnabled = true
        
        messageTable.delegate = self;
        
       /* let gradient: CAGradientLayer! = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.057, 0.065, 0.82, 0.84]
        gradientContainer.layer.mask = gradient;*/
        
        let interestGradient: CAGradientLayer! = CAGradientLayer()
        interestGradient.frame = self.view.bounds
        interestGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        interestGradient.locations = [0.0, 0.25, 0.975, 1]
        interestGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        interestGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        //interestCollectionView.inset = UIEdgeInsetsMake(0, 25, 0, 25);
        
        
        composer = Composer(parent: self);
        self.view.addSubview(composer!.view);
        
        for i in 0...10{
            let user = User(displayName: "Testes", phoneNumber: nil, uuid: nil, accessToken: nil);
            messageTable.addMessage(message: Message(author: user, message: "123 ABC 123 ABC 123 ABC"))
        }
        
        super.view.layoutSubviews()
        interestCollectionView.cornerAndBorder(sides: [.top,.left,.right], corners: [.topLeft,.topRight], color: transparent, thickness: 1, cornerRadius: 10)
        
    }
    func bringDownComposer(){
        parentVC?.dataSource = nil
        composer!.animateDown();
    }
    
    @objc func exitComposer(){
        parentVC?.dataSource = parentVC
    }
    
    var previousScrollMoment: Date = Date()
    var previousScrollX: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        print(contentOffsetY)
        if contentOffsetY <= -200 {
            generator.impactOccurred();
            bringDownComposer()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageTable.cells[indexPath.row].getHeight();
    }
    
}
