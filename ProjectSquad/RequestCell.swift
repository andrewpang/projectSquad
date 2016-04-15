//
//  RequestCell.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 4/14/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class RequestCell: UITableViewCell{
    
    @IBOutlet weak var squadNameLabel: UILabel!
    @IBOutlet weak var leaderNameLabel: UILabel!
    @IBOutlet weak var squadGoalsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func loadItem(squadName: String, name: String, squadGoals: String, time: String) {
        squadNameLabel?.text = squadName
        leaderNameLabel?.text = name
        squadGoalsLabel?.text = squadGoals
        timeLabel?.text = time
        
    }
    
    @IBAction func acceptRequest(sender: AnyObject) {
    }
    
    
    
}