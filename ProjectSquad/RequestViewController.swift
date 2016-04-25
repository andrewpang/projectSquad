//
//  RequestViewController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 4/14/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

protocol CustomCellDelegator {
    func callSegueFromCell(squad: Squad)
}

class RequestViewController: UITableViewController, CustomCellDelegator {
    
    var squadId: [String] = []
    var squadNames: [String] = []
    var leaderNames: [String] = []
    var squadGoals: [String] = []
    var times: [String] = []
    var squads: [Squad] = []
    
//    var squadName: String!
//    var squadGoal: String!
//    var startTime: NSDate!
//    var endTime: NSDate!
//    
//    
    @IBOutlet weak var squadNameLabel: UILabel!
    
    @IBOutlet weak var squadGoalsLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var leaderNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetManager.sharedManager.getSquadRequests({result in
            for(id, name) in result{
                let squadId = id as! String
                NetManager.sharedManager.getSquad(squadId, block: {squadResult in
                    self.squadId.append(squadId)
                    self.squadNames.append(squadResult.name)
                    self.squadGoals.append(squadResult.description)
                    self.leaderNames.append(squadResult.leader)
                    self.times.append("hardcode")
                    self.squads.append(squadResult)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                })
            }

        })
//        NetManager.sharedManager.getFacebookFriends({result in
//            if let friendObjects = result["data"] as? [NSDictionary] {
//                for friendObject in friendObjects {
//                    self.friendIds.append(friendObject["id"] as! String)
//                    self.friendNames.append(friendObject["name"] as! String)
//                }
//                self.tableView.reloadData()
//            }
//        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return squadNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as! RequestCell
        cell.delegate = self
        
        let row = indexPath.row
        cell.loadItem(squads[row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let row = indexPath.row
        
    }
    
    func callSegueFromCell(squad: Squad){
        NetManager.sharedManager.joinSquad(squad, completionBlock: {snapshot in
            self.performSegueWithIdentifier("joinedSquadSegue", sender: nil)
        })
    }
    
}