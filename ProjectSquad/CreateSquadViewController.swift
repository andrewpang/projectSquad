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
    @IBOutlet weak var expirationTime: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    var datePicked: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Squad"
        
        datePicker.addTarget(self, action: #selector(CreateSquadViewController.datePickerChanged), forControlEvents: UIControlEvents.ValueChanged)
        let strDate = "2015-11-01T11:00:00Z" 
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let defaultDate = dateFormatter.dateFromString(strDate)
        datePicker.setDate(defaultDate!, animated: true)
        datePicker.setValue(UIColor(red:1.00, green:0.55, blue:0.60, alpha:1.0), forKeyPath: "textColor")
        datePicked = NSDate().dateByAddingTimeInterval(datePicker.countDownDuration)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(CreateSquadViewController.dismissKeyboard))
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
        self.navigationItem.titleView = containerView
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        datePicked = NSDate().dateByAddingTimeInterval(datePicker.countDownDuration)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a 'on' MMM d, yyyy"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        expirationTime.text = dateFormatter.stringFromDate(datePicked!)
        expiresLabel.text = "Expires at: "
    }

    @IBAction func goToInvite(sender: AnyObject) {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        if(self.squadNameTextField.text!.stringByTrimmingCharactersInSet(whitespace) == ""){
            squadNameTextField.attributedPlaceholder = NSAttributedString(string:"Please enter a squad name", attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        if(self.squadGoalTextField.text!.stringByTrimmingCharactersInSet(whitespace) == ""){
            squadGoalTextField.attributedPlaceholder = NSAttributedString(string:"Please enter a description", attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        if(self.squadNameTextField.text!.stringByTrimmingCharactersInSet(whitespace) != "" && self.squadGoalTextField.text!.stringByTrimmingCharactersInSet(whitespace) != ""){
            self.performSegueWithIdentifier("inviteSegue", sender: nil)
        }
    }
    
    // Text Field is empty - show red border
    func errorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "inviteSegue") {
            
            let addFriendViewController = (segue.destinationViewController as! AddFriendViewController)
            addFriendViewController.squadName = self.squadNameTextField.text!
            addFriendViewController.startTime = NSDate()
            addFriendViewController.endTime = self.datePicked!
            addFriendViewController.squadGoal = self.squadGoalTextField.text!
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}