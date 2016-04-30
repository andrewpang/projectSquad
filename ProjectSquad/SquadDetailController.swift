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
        NetManager.sharedManager.leaveSquad()
        self.performSegueWithIdentifier("leaveSquadSegue", sender: nil)
    }
    
}