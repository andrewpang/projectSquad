//
//  SquadDetailController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 4/29/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class SquadDetailController: UIViewController {
    
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
    

    
}