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
            } else {
                print("Login successful! \(authData!)")
                
                
                /* TODO: 
                    1. Write authData data to Firebase
                    2. Create class to store user data locally
                    3. Store authData data in user data class 
                */
            }
        })
    }
}