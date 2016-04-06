//
//  UserCell.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/31/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class UserCell: UITableViewCell{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var friendId: String!
    
    
    //ifAdded is true, hide the add button
    func loadItem(name: String, uid: String, ifAdded: Bool) {
        nameLabel?.text = name
        friendId = uid
        addButton.hidden = ifAdded
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        addButton.hidden = true
//        NetManager.sharedManager.addFriend(self.friendId, friendUsername: nameLabel.text!)
    }

    

    
}