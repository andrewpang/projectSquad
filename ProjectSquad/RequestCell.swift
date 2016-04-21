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
    var squadId: String = ""
    var delegate:CustomCellDelegator!
    
    func loadItem(squadId:String, squadName: String, name: String, squadGoals: String, time: String) {
        self.squadId = squadId
        squadNameLabel?.text = squadName
        leaderNameLabel?.text = name
        squadGoalsLabel?.text = squadGoals
        timeLabel?.text = time
        
    }
    
    @IBAction func acceptRequest(sender: AnyObject) {
        if(self.delegate != nil){ 
            self.delegate.callSegueFromCell(squadId)
        }
    }
    
    
    
}