//
//  MenuController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 4/12/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class MenuController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let oneSignal = appDelegate.oneSignal
        oneSignal!.IdsAvailable({ (userId, pushToken) in
            NSLog("UserId:%@", userId);
            NetManager.sharedManager.setOneSignalId(userId, completionBlock: {_ in 
                print("OneSignal Id set")
            })
//            if (pushToken != nil) {
//                NSLog("Sending Test Notification to this device now");
//            }
        });
        
        //No updates if it comes here (leave squad, expired squad)
        if NetManager.sharedManager.locationManager != nil{
            NetManager.sharedManager.locationManager!.stopUpdatingLocation()
        }
        
        //If user doesn't have username, make them set one
        NetManager.sharedManager.userHasUsername({
            hasUsername in
            if(!hasUsername){
                self.performSegueWithIdentifier("setUsernameSegue", sender: nil)
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToRequests(sender: AnyObject) {
        self.performSegueWithIdentifier("goToRequestsSegue", sender: nil)
    }
    @IBAction func createSquad(sender: AnyObject) {
        self.performSegueWithIdentifier("createSquadSegue", sender: nil)
    }
}

