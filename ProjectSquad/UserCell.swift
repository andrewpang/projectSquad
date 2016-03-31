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
    
    func loadItem(name: String) {
        nameLabel?.text = name
    }
}