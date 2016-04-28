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
    @IBOutlet weak var squadGoalTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Squad"
//        datePicker.setValue(UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0), forKeyPath: "textColor")
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let containerView = UIView()
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: self.title!)
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        containerView.frame.size.height = titleLabel.frame.size.height
        containerView.frame.size.width = titleLabel.frame.size.width + titleLabel.frame.size.height
//        //containerView.userInteractionEnabled = true
//        
//        let backTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.backToMap))
        
        containerView.addSubview(titleLabel)
        
        self.tabBarController?.tabBar.hidden = true
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChatViewController.backToMap))
        
        self.navigationItem.titleView = containerView
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
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
            addFriendViewController.startTime = NSDate()
            addFriendViewController.endTime = self.endTimeDatePicker.date
            addFriendViewController.squadGoal = self.squadGoalTextField.text!
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}