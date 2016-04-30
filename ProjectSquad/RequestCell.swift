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
    var currentSquad: Squad?
    
    func loadItem(squad: Squad, leaderName: String) {
        self.squadId = squad.id
        squadNameLabel?.text = squad.name
        leaderNameLabel?.text = leaderName
        squadGoalsLabel?.text = "\"" + squad.description + "\""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a 'on' MM-dd-yyyy"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        timeLabel?.text = dateFormatter.stringFromDate(squad.endTime)
        currentSquad = squad
    }
    
    @IBAction func acceptRequest(sender: AnyObject) {
        if(self.delegate != nil){ 
            self.delegate.callSegueFromCell(currentSquad!)
        }
    }
    
    @IBAction func deleteRequest(sender: AnyObject) {
        if(self.delegate != nil){
            self.delegate.deleteRequestFromCell(currentSquad!)
        }
    }
    
    
}