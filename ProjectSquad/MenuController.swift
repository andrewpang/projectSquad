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
        
        // Do any additional setup after loading the view.
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

