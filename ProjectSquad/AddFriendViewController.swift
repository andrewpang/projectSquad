//
//  AddFriendViewController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/31/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let test = ["hi", "this", "is", "fun"]
    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        
        
        let row = indexPath.row
        cell.loadItem(test[row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(test[row])
    }
    
}