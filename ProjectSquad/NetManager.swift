//
//  NetManager.swift
//  ProjectSquad
//
//  Created by Tate Allen on 1/30/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation
import Firebase

class NetManager {
    
    static let sharedManager = NetManager()
    private let firebaseRefURL = "https://squad-development.firebaseio.com/"
    private var currentUserData: User?
    private var currentSquadData: Squad?
    
    func loginWithToken(token: FBSDKAccessToken, completionBlock: (success: Bool, hasUsername: Bool) -> Void) {
        let ref = Firebase(url: self.firebaseRefURL)
        
        ref.authWithOAuthProvider("facebook", token: token.tokenString, withCompletionBlock: { (error: NSError?, authData: FAuthData?) -> Void in
            if let error = error {
                // TODO: Handle errors
                print("Error logging in \(error)")
            } else if let authData = authData {
                print("Login successful! \(authData)")
                
                let provider = authData.provider
                let uid = authData.uid
                let displayName = authData.providerData["displayName"] as! String
                let email = authData.providerData["email"] as! String
                let profPicURL = authData.providerData["profileImageURL"] as! String
                
                self.currentUserData = User(uid: uid, provider: provider, displayName: displayName, email: email, picURL: profPicURL)
                
                let userRef = ref.childByAppendingPath("users").childByAppendingPath(uid)
                userRef.updateChildValues(self.currentUserData!.returnFBUserDict(), withCompletionBlock: { (error: NSError?, firebase: Firebase!) -> Void in
                    if error == nil {
                        firebase.observeSingleEventOfType(.Value, withBlock: { (snapshot: FDataSnapshot!) -> Void in
                            if snapshot.value["username"]! == nil {
                                completionBlock(success: true, hasUsername: false)
                            } else {
                                completionBlock(success: true, hasUsername: true)
                            }
                        })
                    } else {
                        completionBlock(success: false, hasUsername: false)
                    }
                })
            }
        })
    }
    
    func addFriend(uid: String, friendID: String, friendUsername: String) {
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        let friendsRef = ref.childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("friends")
        friendsRef.updateChildValues([friendID: friendUsername],
            withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
            if let error = error {
                print("Error sending profile info! \(error)")
            }
        })
    }
    
    func getFriends(uid: String) {
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        let friendsRef = ref.childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("friends")
        friendsRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    
    func setUsername(username: String, completionBlock: (error: NSError?) -> Void) {
        let ref = Firebase(url: self.firebaseRefURL).childByAppendingPath("users").childByAppendingPath(self.currentUserData!.uid)

        ref.updateChildValues(["username": username]) { (error: NSError?, firebase: Firebase!) -> Void in
            completionBlock(error: error)
        }
    }
    
    func getUserByUsername(username: String) {
        let ref = Firebase(url: "https://squad-development.firebaseio.com/users");
        ref.queryOrderedByChild("username").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let username = snapshot.value["username"] as? String {
                print("\(snapshot.key) is \(username) and \(snapshot.childSnapshotForPath("email"))")
            }
        })
    }
    
    func setSquad(name: String, startTime: NSDate, endTime: NSDate, description: String, members: [String: String]) {
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        let squadRef = ref.childByAppendingPath("squad")
        let squad1Ref = squadRef.childByAutoId()
        let membersRef = squad1Ref.childByAppendingPath("members")
        
//        let leader =  self.currentUserData!.uid
        let leader = "hardcode"
        self.currentSquadData = Squad(name: name, startTime: startTime, endTime: endTime, description: description, leader: leader)
        
        
        squad1Ref.setValue(self.currentSquadData?.returnSquadDict(), withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                if let error = error {
                    print("Error sending profile info! \(error)")
                } else{
                    //If no error with setting squad, set members of squad
                    membersRef.setValue(members,
                        withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                        if let error = error {
                            print("Error sending profile info! \(error)")
                        }
                    })
            }
        })

        
        
    }
    
    
    
    
    
    

    
}