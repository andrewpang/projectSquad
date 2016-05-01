//
//  UserCell.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/31/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

protocol UserCellDelegate {
    func cellButtonTapped(cell: UserCell)
}

class UserCell: UITableViewCell{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var friendId: String!
    var delegate: UserCellDelegate?
    
    //ifAdded is true, hide the add button
    func loadItem(name: String, uid: String, ifAdded: Bool) {
        nameLabel?.text = name
        friendId = uid
        addButton.hidden = ifAdded
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        if(addButton.tintColor == UIColor.greenColor()){
            addButton.tintColor = UIColor(red:1.00, green:0.55, blue:0.60, alpha:1.0)
        }else{
            addButton.tintColor = UIColor.greenColor()
        }
        delegate?.cellButtonTapped(self)
    }

    

    
}