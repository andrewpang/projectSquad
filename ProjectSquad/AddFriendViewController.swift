//
//  AddFriendViewController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/31/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendNames = ["hi"]
    var friendIds = ["hi"]
    var squadInvites = ["hi":"hi"]
    
    var squadName: String!
    var startTime: NSDate!
    var endTime: NSDate!
    var squadGoal: String!

    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        NetManager.sharedManager.getFacebookFriends({result in
            if let friendObjects = result["data"] as? [NSDictionary] {
                for friendObject in friendObjects {
                    self.friendIds.append(friendObject["id"] as! String)
                    self.friendNames.append(friendObject["name"] as! String)
                }
                self.tableView.reloadData()
            }
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        
        
        let row = indexPath.row
        //TODO: compare to current users friend list to set ifAdded
        cell.loadItem(friendNames[row], uid: friendIds[row], ifAdded: false)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
    }
    
    @IBAction func createSquad(sender: AnyObject) {
        NetManager.sharedManager.setSquad(squadName, startTime: startTime, endTime: endTime, description: squadGoal, members: squadInvites)
        self.performSegueWithIdentifier("createdSquadSegue", sender: nil)
    }

}