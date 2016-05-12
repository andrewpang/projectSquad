//
//  SquadDetailController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 4/29/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class SquadDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var squadName: String?
    var members: [String] = []
    var memberIds: [String] = []
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var memberTableView: UITableView!
    
    override func viewDidLoad() {
        memberTableView.dataSource = self
        
        self.squadName = NetManager.sharedManager.currentSquadData!.name
        let endTime = NetManager.sharedManager.currentSquadData!.endTime
        let squadMembers = NetManager.sharedManager.currentSquadData!.members
        for(name, id) in squadMembers{
            members.append(name)
            memberIds.append(id)
        }
        
        let containerView = UIView()
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: self.squadName!)
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        containerView.frame.size.height = titleLabel.frame.size.height
        containerView.frame.size.width = titleLabel.frame.size.width + titleLabel.frame.size.height
        containerView.addSubview(titleLabel)
        
        self.navigationItem.titleView = containerView
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a 'on' MMM d"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        expirationLabel?.text = "Expires at: " + dateFormatter.stringFromDate(endTime)
        
        self.memberTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MemberCell = self.memberTableView.dequeueReusableCellWithIdentifier("MemberCell") as! MemberCell
        cell.loadItem(members[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }
    
    @IBAction func inviteFriends(sender: AnyObject) {
        self.performSegueWithIdentifier("inviteMoreSegue", sender: nil)
    }
    @IBAction func leaveSquad(sender: AnyObject) {
        // create the alert
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to leave this squad?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: {
            action in
            NetManager.sharedManager.leaveSquad({
                block in
                self.performSegueWithIdentifier("leaveSquadSegue", sender: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inviteMoreSegue" {
            if let addViewController = segue.destinationViewController as? AddFriendViewController {
                addViewController.isExistingSquad = true
                addViewController.existingMembers = memberIds
            }
        }
    }
    

    
}