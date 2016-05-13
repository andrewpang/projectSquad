//
//  AddFriendViewController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/31/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserCellDelegate {
    
    var friendNames: [String] = []
    var friendIds:[String] = []
    var squadInvites: [String: String] = [:]
    
    var squadName: String!
    var startTime: NSDate!
    var endTime: NSDate!
    var squadGoal: String!

    @IBOutlet weak var createSquadButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "UserCell"
    
    var isExistingSquad = false
    var existingMembers: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isExistingSquad){
            createSquadButton.setTitle("Invite", forState: UIControlState.Normal)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        NetManager.sharedManager.getFacebookFriends({result in
            if let friendObjects = result["data"] as? [NSDictionary] {
                for friendObject in friendObjects {
                    let fbId = "facebook:" + (friendObject["id"] as! String)
                    if(self.isExistingSquad){
                        let members = self.existingMembers!
                        if(members.contains(fbId)){
                            continue
                        }
                    }
                    self.friendIds.append(fbId)
                    self.friendNames.append(friendObject["name"] as! String)
                }
                self.tableView.reloadData()
            }
        })
        
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: "ADD FRIENDS")
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.titleView = titleLabel
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendNames.count == 0{
            
            let size: CGSize = self.tableView.frame.size;
            let emptyLabel = UILabel(frame: CGRectMake(0,0, size.width, size.height))
            emptyLabel.textColor = UIColor(red:1.00, green:0.55, blue:0.60, alpha:1.0)
            emptyLabel.text = "None of your friends have Squad :("
            emptyLabel.textAlignment = NSTextAlignment.Center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else {
            self.tableView.backgroundView = nil
            return friendNames.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        cell.delegate = self
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
        if(isExistingSquad){
            NetManager.sharedManager.inviteMore(squadInvites)
            self.performSegueWithIdentifier("invitedMoreSegue", sender: nil)
        }
        else{
        
            NetManager.sharedManager.setSquad(squadName, startTime: startTime, endTime: endTime, description: squadGoal, invites: squadInvites)
            self.performSegueWithIdentifier("createdSquadSegue", sender: nil)
        }
    }
    
    func cellButtonTapped(cell: UserCell) {
        let indexPath = self.tableView.indexPathForRowAtPoint(cell.center)!
        let selectedName = friendNames[indexPath.row]
        let selectedId = friendIds[indexPath.row]
        
        if (squadInvites.indexForKey(selectedName) != nil) {
            squadInvites.removeValueForKey(selectedName)
        } else {
            squadInvites[selectedName] = selectedId
        }
    }

}