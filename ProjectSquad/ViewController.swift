//
//  ViewController.swift
//  ProjectSquad
//
//  Created by Tate Allen on 1/28/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import CoreLocation

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

    
//    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }

    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("User already logged in!")
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, name, picture"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil)
                {
                    //print("result \(result)")
                    let resultDict = result as! [String: AnyObject]
                    var uid = "facebook:"
                    uid += resultDict["id"] as! String
                    let user = User(uid: uid, provider: "FB", displayName: resultDict["name"] as! String, email: resultDict["email"] as! String, picURL: resultDict["picture"]!["data"]!!["url"] as! String)
                    NetManager.sharedManager.setCurrentUser(user)
                    //See if user has a current squad and if that squad is valid
                    NetManager.sharedManager.checkUserCurrentSquad({
                        squadId in
                        if(squadId != ""){
                            NetManager.sharedManager.getSquad(squadId, block: {
                                squad in
                                NetManager.sharedManager.currentSquadData = squad
                                let now = NSDate()
                                if(squad.endTime.compare(now) == .OrderedAscending){
                                    NetManager.sharedManager.leaveSquad({
                                        block in
//                                        let menuController = UIViewController(nibName: "MenuController", bundle: nil)
//                                        self.presentViewController(menuController, animated: true, completion: nil)
//
                                        self.performSegueWithIdentifier("loggedInSegue", sender: nil)
                                    })
                                }else{
                                    self.performSegueWithIdentifier("hasSquadSegue", sender: nil)
                                }
                            })
                        }else{
                            self.performSegueWithIdentifier("loggedInSegue", sender: nil)
                        }
                    })
                    
                }
                else
                {
                    print("error \(error)")
                }
            })
            
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton?, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: NSError?) {
        if let error = error {
            print("Error logging in \(error)")
        } else if let result = result, token = result.token {
            NetManager.sharedManager.loginWithToken(token, completionBlock: { (success: Bool, hasUsername: Bool) -> Void in
                if success && hasUsername {
                    print("User logged in successfully!")
                    self.performSegueWithIdentifier("loggedInSegue", sender: nil)
                } else if !hasUsername {
                    print("User doesn't have a username!")
                    self.performSegueWithIdentifier("setUsernameSegue", sender: nil)
                } else {
                    print("Error logging in!")
                }
            })
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
    
    
//    @IBAction func test(){
//        NetManager.sharedManager.getFacebookFriends({result in
//            if let friendObjects = result["data"] as? [NSDictionary] {
//                for friendObject in friendObjects {
//                    print(friendObject["id"] as! NSString)
//                    print(friendObject["name"] as! NSString)
//                }
//            }
//        })
//    }
    

    
    
    
    
}

