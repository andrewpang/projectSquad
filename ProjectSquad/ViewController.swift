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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var testImageView: UIImageView!
 
    @IBOutlet weak var imageView: UIImageView!
    
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
        
//                ImageLoader.sharedLoader.imageForUrl("https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12743778_10153667545016387_7753665671545921054_n.jpg?oh=d0d4a8b3935b302e362e15daee44e8a2&oe=578077E6", completionHandler:{(image: UIImage?, url: String) in
//                    self.testImageView.image = image
////                    JSQMessagesAvatarImage(avatarImage: image!, highlightedImage: image!, placeholderImage: image!)
////                    self.reloadMessagesView()
//                })

//        imageView.kf_setImageWithURL(NSURL(string: "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12743778_10153667545016387_7753665671545921054_n.jpg?oh=d0d4a8b3935b302e362e15daee44e8a2&oe=578077E6")!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
//            self.testImageView.image = image
//        })
        
        
//        let url = NSURL(fileURLWithPath: "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12743778_10153667545016387_7753665671545921054_n.jpg?oh=d0d4a8b3935b302e362e15daee44e8a2&oe=578077E6")
//        ImageDownloader(name: "imageDL").downloadImageWithURL(url, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
//                self.testImageView.image = image
//        })
        
        
        
        
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
    
    
    @IBAction func test(){
        NetManager.sharedManager.getFacebookFriends({result in
            if let friendObjects = result["data"] as? [NSDictionary] {
                for friendObject in friendObjects {
                    print(friendObject["id"] as! NSString)
                    print(friendObject["name"] as! NSString)
                }
            }
        })
    }
    

    
    
    
    
}

