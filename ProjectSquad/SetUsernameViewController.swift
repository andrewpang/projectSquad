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
        if(self.usernameTextField.text!.stringByTrimmingCharactersInSet(whitespace) == ""){
            usernameTextField.attributedPlaceholder = NSAttributedString(string:"Please enter a username", attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        else{
            NetManager.sharedManager.setUsername(self.usernameTextField.text!) { (error: NSError?) -> Void in
                if error == nil {
                    print("Successfully set username!")
                    self.performSegueWithIdentifier("usernameSetSegue", sender: nil)
                } else {
                    print("Couldn't set username!")
                }
            }
        }
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
