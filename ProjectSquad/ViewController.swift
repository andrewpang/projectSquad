//
//  ViewController.swift
//  ProjectSquad
//
//  Created by Tate Allen on 1/28/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            // User is already logged in, do work such as go to next view controller.
//        }
//        else
//        {
//           
//        }
        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton?, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: NSError?) {
        if let error = error {
            print("Error logging in \(error)")
        } else if let result = result, token = result.token {
            NetManager.sharedManager.loginWithToken(token)
        } else {
            print("Not logged in!")
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //print("logged out!")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

