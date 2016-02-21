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
    
    func loginWithToken(token: FBSDKAccessToken) {
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        
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
                
                let userData = User(uid: uid, provider: provider, displayName: displayName, email: email, picURL: profPicURL)
                
                let userRef = ref.childByAppendingPath("users").childByAppendingPath(uid)
                userRef.setValue(userData.returnFBUserDict(), withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                    if let error = error {
                        print("Error sending profile info! \(error)")
                    }
                })
                
                
                /* TODO: 
                    1. Write authData data to Firebase
                    2. Create class to store user data locally
                    3. Store authData data in user data class 
                */
            }
        })
    }
    
    func addFriend(uid: String, friendID: String, friendUsername: String){
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        let friendsRef = ref.childByAppendingPath("friendLists").childByAppendingPath(uid)
        friendsRef.updateChildValues([friendID: friendUsername],
            withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
            if let error = error {
                print("Error sending profile info! \(error)")
            }
        })
    }
    
    func getFriends(uid: String){
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        let friendsRef = ref.childByAppendingPath("friendLists").childByAppendingPath(uid)
        friendsRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            }, withCancelBlock: { error in
                print(error.description)
        })
    
}
    
    
    
}