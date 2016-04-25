//
//  Squad.swift
//  ProjectSquad
//
//  Created by Tate Allen on 2/21/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class Squad {
    
    var id: String
    var name: String
    var startTime: NSDate
    var endTime: NSDate
    var description: String
    var leader: String
    var members: [String: String]
    
    init(id:String, name: String, startTime: NSDate, endTime: NSDate, description: String, leaderId:String, members:[String: String]) {
        self.id = id 
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
        self.leader = leaderId
        self.members = members
    }
    
    func addMember(uid: String, username: String){
        members.updateValue(uid, forKey: username)
    }
    
    func deleteMember(username: String){
        members.removeValueForKey(username)
    }
    
    func returnSquadDict() -> [String: String]{
        let startInterval = self.startTime.timeIntervalSince1970
        let endInterval = self.endTime.timeIntervalSince1970
        let data: [String: String] = [
            "name" : self.name,
            "startTime" : "\(startInterval)",
            "endTime" : "\(endInterval)",
            "description" : self.description,
            "leader" : self.leader
        
        ]
        return data
    }
    
    
    
}