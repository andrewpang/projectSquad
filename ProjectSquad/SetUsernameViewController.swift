//
//  SetUsernameViewController.swift
//  ProjectSquad
//
//  Created by Tate Allen on 2/21/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit

class SetUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(SetUsernameViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setUsername(sender: AnyObject) {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        let trimmed = self.usernameTextField.text!.stringByTrimmingCharactersInSet(whitespace)

        let range = trimmed.rangeOfCharacterFromSet(whitespace)
        //Check blank
        if(trimmed == ""){
            self.usernameTextField.text = ""
            let alert = UIAlertController(title: "Please enter a valid username", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        //Check if username is too long
        else if(trimmed.characters.count > 20){
            self.usernameTextField.text = ""
            let alert = UIAlertController(title: "Please enter a username with less than 20 characters", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        // range will be nil if no whitespace is found
        else if let test = range {
            self.usernameTextField.text = ""
            let alert = UIAlertController(title: "Please enter valid username with no spaces", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            NetManager.sharedManager.setUsername(trimmed) { (error: NSError?) -> Void in
                                        if error == nil {
                                            print("Successfully set username!")
                                            self.performSegueWithIdentifier("usernameSetSegue", sender: nil)
                                        } else {
                                            print("Couldn't set username!")
                                        }
                                    }
            //TODO:  Check if username exists already
//            NetManager.sharedManager.checkUsername(trimmed, block: {
//                result in
//                if(result == true){
//                    self.usernameTextField.text = ""
//                    let alert = UIAlertController(title: "Username taken", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }else{
//                    NetManager.sharedManager.setUsername(trimmed) { (error: NSError?) -> Void in
//                        if error == nil {
//                            print("Successfully set username!")
//                            self.performSegueWithIdentifier("usernameSetSegue", sender: nil)
//                        } else {
//                            print("Couldn't set username!")
//                        }
//                    }
//                }
//            })
        }
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
