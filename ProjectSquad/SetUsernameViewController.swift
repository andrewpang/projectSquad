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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setUsername(sender: AnyObject) {
        NetManager.sharedManager.setUsername(self.usernameTextField.text!) { (error: NSError?) -> Void in
            if error == nil {
                print("Successfully set username!")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("Couln't set username!")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
