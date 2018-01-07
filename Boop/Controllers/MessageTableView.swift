//
//  MessageTableView.swift
//  Boop
//
//  Created by Sam Gehly on 1/2/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class MessageTableView: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var cells: [MessageTableViewCell] = [];
    
    var noView: UIView? = nil;
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self;
        self.dataSource = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = UIView(frame: CGRect.zero)
        self.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row];
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].getHeight();
    }
    
    
    func addMessage(message: Message){

        let cell = MessageTableViewCell(style: .default, reuseIdentifier: "thing", table: self, index: cells.count, message: message);
        
        self.beginUpdates();
        cells.append(cell);        
        self.insertRows(at: [IndexPath(row: cells.count-1, section: 0)], with: UITableViewRowAnimation.fade)
        self.endUpdates();
        
        if(noView != nil){
            noView?.isHidden = cells.count > 0;
        }
    }
    
    func removeMessage(message: Message){
        self.beginUpdates();
        
        var index = 0;
        for cell in cells {
            if(cell.MV!.reference === message){
                break;
            }
            index = index+1;
        }
        let lookupIndex = IndexPath(item: index, section: 0)
        cells.remove(at: index)
        self.deleteRows(at: [lookupIndex], with: UITableViewRowAnimation.fade)
        self.endUpdates();
        
        if(noView != nil){
            noView?.isHidden = cells.count > 0;
        }
    }
    
}

class MessageTableViewCell: UITableViewCell{
    
    var MV: MessageViewController? = nil;
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, table: MessageTableView, index: Int, message: Message) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        MV = MessageViewController(reference: message, table: table, row: index);
        
        self.backgroundColor = UIColor.clear;
        self.contentView.backgroundColor = UIColor.clear;
        self.contentView.addSubview(MV!.view);
        
        
        self.contentView.frame = MV!.view.frame;
        self.frame = self.contentView.frame;
        
        self.selectionStyle = .none
    }
    
    func initializeTimer(){
        MV?.initializeTimer();
    }
    
    
    func getHeight() -> CGFloat{
        return MV!.getHeight();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
