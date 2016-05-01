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
        let myname = NetManager.sharedManager.currentUserData?.displayName
        let name = NetManager.sharedManager.currentSquadData?.name
        print(name)
        NetManager.sharedManager.leaveSquad({
            block in
            self.performSegueWithIdentifier("leaveSquadSegue", sender: nil)
        })
        
    }
    
}