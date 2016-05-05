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
    func deleteRequestFromCell(squad: Squad)
}

class RequestViewController: UITableViewController, CustomCellDelegator {
    
    var squadId: [String] = []
    var squadNames: [String] = []
    var leaderNames: [String] = []
    var squadGoals: [String] = []
    var endTimes: [NSDate] = []
    var squads: [Squad] = []
    
    @IBOutlet weak var squadNameLabel: UILabel!
    
    @IBOutlet weak var squadGoalsLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var leaderNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Invites"
        let containerView = UIView()
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: self.title!)
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        containerView.frame.size.height = titleLabel.frame.size.height
        containerView.frame.size.width = titleLabel.frame.size.width + titleLabel.frame.size.height
        containerView.addSubview(titleLabel)
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.titleView = containerView
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        NetManager.sharedManager.getSquadRequests({result in
            self.squadId.removeAll()
            self.squadNames.removeAll()
            self.leaderNames.removeAll()
            self.squadGoals.removeAll()
            self.endTimes.removeAll()
            self.squads.removeAll()
            for(id, name) in result{
                let squadId = id as! String
                NetManager.sharedManager.getSquad(squadId, block: {squadResult in
                    let now = NSDate()
                    if(squadResult.endTime.compare(now) == .OrderedDescending){
                        NetManager.sharedManager.getUserByUID(squadResult.leader, block: {user in
                            self.squadId.append(squadId)
                            self.squadNames.append(squadResult.name)
                            self.squadGoals.append(squadResult.description)
                            self.endTimes.append(squadResult.endTime)
                            self.leaderNames.append(user.displayName)
                            self.squads.append(squadResult)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                            }
                        })
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
        if squadNames.count == 0{
            let size: CGSize = self.tableView.frame.size;
            var emptyLabel = UILabel(frame: CGRectMake(0,0, size.width, size.height))
            emptyLabel.textColor = UIColor(red:1.00, green:0.55, blue:0.60, alpha:1.0)
            emptyLabel.text = "You currently have no invites"
            emptyLabel.textAlignment = NSTextAlignment.Center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else {
            return squadNames.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as! RequestCell
        cell.delegate = self
        
        let row = indexPath.row
        cell.loadItem(squads[row], leaderName: leaderNames[row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let row = indexPath.row
        print("Pressed")
        
    }
    
    func callSegueFromCell(squad: Squad){
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you would like to join this squad?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Join", style: UIAlertActionStyle.Default, handler: {
            action in
            NetManager.sharedManager.joinSquad(squad, completionBlock: {snapshot in
                self.performSegueWithIdentifier("joinedSquadSegue", sender: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteRequestFromCell(squad: Squad){
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you would delete this request?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {
            action in
            NetManager.sharedManager.deleteSquadRequest(squad, completionBlock: {snapshot in
                self.tableView.reloadData()
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

}