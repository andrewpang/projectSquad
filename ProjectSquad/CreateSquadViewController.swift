//
//  CreateSquadViewController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/29/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class CreateSquadViewController: UIViewController{

    @IBOutlet weak var squadNameTextField: UITextField!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToInvite(sender: AnyObject) {
        
        self.performSegueWithIdentifier("inviteSegue", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "inviteSegue") {
            
            let addFriendViewController = (segue.destinationViewController as! AddFriendViewController)
            addFriendViewController.squadName = self.squadNameTextField.text!
            addFriendViewController.startTime = self.startTimeDatePicker.date
            addFriendViewController.endTime = self.endTimeDatePicker.date
            addFriendViewController.squadGoal = "HI"
        }
    }



}