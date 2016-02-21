//
//  User.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 1/30/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class User{
    var uid: String
    var username: String?
    var provider: String
    var displayName: String
    var email: String
    var picURL: String
    var friends: [String]?
    
    init(uid: String, provider: String, displayName: String, email: String, picURL: String){
        self.uid = uid
        self.provider = provider
        self.displayName = displayName
        self.email = email
        self.picURL = picURL
    }
    
    func returnFBUserDict() -> [String: String]{
        let data: [String: String] = [
            "provider": self.provider,
            "displayName": self.displayName,
            "email": self.email,
            "picURL": self.picURL
        ]
        return data
    }
}