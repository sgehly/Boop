//
//  InterestCreator.swift
//  Boop
//
//  Created by Sam Gehly on 1/7/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

let colors: [String:String] = ["red":"e74c3c","blue":"3498db","green":"2ecc71","yellow":"f1c40f","orange":"e67e22","purple":"9b59b6"]
class InterestCreator: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var interestField: UITextView!

    @IBOutlet var colorCollection: UICollectionView!
    
    convenience init(){
        self.init(nibName: "InterestCreator", bundle: Bundle.main)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.interestField.placeholder = "What's on your mind kiddo?"
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white;
        self.view.frame = CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        colorCollection.dataSource = self;
        colorCollection.delegate = self;
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardRectangle.minY)
            self.addButton.frame = CGRect(x: self.addButton.frame.minX, y: keyboardRectangle.minY-self.addButton.frame.height-15, width: self.addButton.frame.width, height: self.addButton.frame.height)
            self.cancelButton.frame = CGRect(x: self.cancelButton.frame.minX, y: self.addButton.frame.minY, width: self.cancelButton.frame.width, height: self.cancelButton.frame.height)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        let view = UIView()
        let index = Array(colors)[indexPath.row].key;
        print(index);
        print(colors[index])
        view.backgroundColor = UIColor().HexToColor(hexString: colors[index]!)
        view.frame = cell.contentView.frame;
        cell.contentView.addSubview(view);
        return cell
    }
}
