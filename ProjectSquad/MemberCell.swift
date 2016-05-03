//
//  MemberCell.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 5/2/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class MemberCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func loadItem(name: String) {
        nameLabel?.text = name
    }
  
}