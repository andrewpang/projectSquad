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

    @IBAction func createSquad(){
        let squadName = self.squadNameTextField.text!
        let startTime = self.startTimeDatePicker.date
        let endTime = self.endTimeDatePicker.date
        let description = "HI"
        let members = ["me": "1231", "asfk": "aslf"]
        
        NetManager.sharedManager.setSquad(squadName, startTime: startTime, endTime: endTime, description: description, members: members)
        
    }





}