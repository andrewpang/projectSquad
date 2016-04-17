//
//  NetManager.swift
//  ProjectSquad
//
//  Created by Tate Allen on 1/30/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation
import Firebase
import MapKit
import JSQMessagesViewController
import GeoFire

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
    
    func addFriend(friendID: String, friendUsername: String) {
        let friendsRef = Firebase(url:self.firebaseRefURL).childByAppendingPath("users").childByAppendingPath(currentUserData!.uid).childByAppendingPath("friends")
        friendsRef.updateChildValues([friendID: friendUsername],
            withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
            if let error = error {
                print("Error sending profile info! \(error)")
            }
        })
    }
    
    func getFriends(uid: String) {
        let friendsRef = Firebase(url:self.firebaseRefURL).childByAppendingPath("users").childByAppendingPath(uid).childByAppendingPath("friends")
        friendsRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func getFacebookFriends(block: (resultDict: NSDictionary) -> Void) {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields": "id, name, location"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            var resultDictionary:NSDictionary!
            
            if error == nil {
                resultDictionary = result as! [String: AnyObject]
                block(resultDict: resultDictionary)
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }
    
    
    func setUsername(username: String, completionBlock: (error: NSError?) -> Void) {
        let ref = Firebase(url: self.firebaseRefURL).childByAppendingPath("users").childByAppendingPath(self.currentUserData!.uid)

        ref.updateChildValues(["username": username]) { (error: NSError?, firebase: Firebase!) -> Void in
            completionBlock(error: error)
        }
    }
    
    //MARK: - Location
//    func listenForLocationUpdates() {
//        let ref = self.getFirebaseLocationsRef()
//        ref.observeEventType(FEventType.ChildAdded) { (snapshot: FDataSnapshot?) -> Void in
//            self.processChildAddedAndChanged(snapshot)
//        }
//        
//        ref.observeEventType(FEventType.ChildChanged) { (snapshot: FDataSnapshot?) -> Void in
//            self.processChildAddedAndChanged(snapshot)
//        }
//    }
    
//    private func processChildAddedAndChanged(snapshot: FDataSnapshot?) {
//        if let snapshot = snapshot {
//            if !(snapshot.value is NSNull) {
//                if snapshot.key != self.currentUserData!.uid {
//                    let geoRef = self.getUserLocationRef(snapshot.key)
//                    let geofire = GeoFire(firebaseRef: geoRef)
//                    geofire.getLocationForKey("loc") { (location: CLLocation?, error: NSError?) -> Void in
//                        if let location = location {
//                            let uid = snapshot.key
//                            if let user = self.getUserWithUID(uid) {
//                                user.location = location
//                                self.delegate?.userLocationUpdated(user, isNew: false)
//                            } else {
//                                let newUser = UserData(uid: uid, location: location)
//                                self.users.append(newUser)
//                                self.delegate?.userLocationUpdated(newUser, isNew: true)
//                            }
//                        } else {
//                            print("Location was nil")
//                        }
//                    }
//                }
//            } else {
//                print("Snapshot.value was NSNull")
//            }
//        } else {
//            print("Snapshot was nil")
//        }
//    }
    
    func stopListeningForLocationUpdates() {
        
    }
    
    func updateCurrentLocation(currentLocation: CLLocation) {
        if let ref = self.getCurrentUserLocationRef() {
            let geofire = GeoFire(firebaseRef: ref)
            geofire.setLocation(currentLocation, forKey: "loc") { (error: NSError?) -> Void in
                if let error = error {
//                    self.delegate?.didSetLocation(error)
                } else {
//                    self.delegate?.didSetLocation(nil)
                }
            }
        } else {
            print("Could NOT update location. User not authenticated.")
        }
    }

    func getUserByUsername(username: String) {
        let ref = Firebase(url:self.firebaseRefURL).queryOrderedByChild("username").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let username = snapshot.value["username"] as? String {
                print("\(snapshot.key) is \(username) and \(snapshot.childSnapshotForPath("email"))")
            }
        })
    }
    
    //Send a request to user to join a squad
    func sendSquadRequest(userId: String, squadId: String) {
        let requestRef = Firebase(url: self.firebaseRefURL).childByAppendingPath("users").childByAppendingPath(userId).childByAppendingPath("requests")
        
        requestRef.updateChildValues(["squadId": squadId],
            withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                if let error = error {
                    print("Error sending profile info! \(error)")
                }
            })
    }
    
    func setSquad(name: String, startTime: NSDate, endTime: NSDate, description: String, invites: [String: String]) {
        let squadRef = Firebase(url:self.firebaseRefURL).childByAppendingPath("squads")
        let squad1Ref = squadRef.childByAutoId()
        let membersRef = squad1Ref.childByAppendingPath("members")
        
//        let leader =  self.currentUserData!.uid
        let leaderId = self.currentUserData!.uid
        let leadername = self.currentUserData!.displayName
        let leader = [self.currentUserData!.displayName : self.currentUserData!.uid]
//        let leader = ["Andrew Pang":"facebook:10153631255636387"]
        
        self.currentSquadData = Squad(name: name, startTime: startTime, endTime: endTime, description: description, leaderId: leaderId, leaderUsername: leadername)
        
        
        squad1Ref.setValue(self.currentSquadData?.returnSquadDict(), withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                if let error = error {
                    print("Error sending profile info! \(error)")
                } else{
                    //If no error with setting squad, set members of squad
                    membersRef.setValue(leader ,
                        withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                        if let error = error {
                            print("Error sending profile info! \(error)")
                        }
                    })
            }
        })
        for(inviteeName, inviteeId) in invites{
            sendSquadRequest(inviteeId, squadId: squad1Ref.key)
        }

        
    }
    

    
    func getSquadRequests() {
        let requestsRef = Firebase(url:self.firebaseRefURL).childByAppendingPath("users").childByAppendingPath(self.currentUserData?.uid).childByAppendingPath("requests")
        
        requestsRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    //Add current user to a squad
    func joinSquad(squadId: String, completionBlock: (error: NSError?) -> Void) {
        let squadRef = Firebase(url:self.firebaseRefURL).childByAppendingPath("squads").childByAppendingPath(squadId)
        
        squadRef.updateChildValues([(self.currentUserData?.uid)!: (self.currentUserData?.username)!]) { (error: NSError?, firebase: Firebase!) -> Void in
            completionBlock(error: error)
        }
    }
    
    //Add a new message to a chat
    func addChatMessage(message: JSQMessage, groupId: String){
        let chatRef = Firebase(url:self.firebaseRefURL).childByAppendingPath("chat")
        let groupChatRef = chatRef.childByAppendingPath(groupId)
        let messageRef = groupChatRef.childByAutoId()
        
        messageRef.setValue([
                "text": message.text,
                "sender": message.senderId,
                "senderName": message.senderDisplayName,
                "date": FirebaseServerValue.timestamp()
            ], withCompletionBlock: { (error: NSError?, firebase: Firebase?) -> Void in
                if let error = error {
                    print("Error adding chat message! \(error)")
                }
        })
        
    }
    
//    //Return array of JSQMessages
//    func getChatMessages(groupId: String, completion: (result: [JSQMessage]) -> Void) -> [JSQMessage]{
//        var messages = [JSQMessage]()
//        
//        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
//        let chatRef = ref.childByAppendingPath("chat")
//        let groupChatRef = chatRef.childByAppendingPath(groupId)
//        
//        groupChatRef.queryLimitedToLast(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
//            let text = snapshot.value["text"] as? String
//            let id = snapshot.value["sender"] as? String
//            let name = snapshot.value["senderName"] as? String
//            let dateInterval = snapshot.value["date"] as? NSTimeInterval
//            let date = NSDate(timeIntervalSince1970: dateInterval!)
//            
//            let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, text: text)
//            messages.append(message)
//        })
//        return messages
//    }
//
    
    //MARK: - Helpers
    private func getFirebaseRef() -> Firebase {
        return Firebase(url: self.firebaseRefURL)
    }
    
    private func getFirebaseLocationsRef() -> Firebase {
        return Firebase(url: self.firebaseRefURL).childByAppendingPath("locations")
    }
    
    private func getCurrentUserRef() -> Firebase {
//        if let currentUserUID = currentUserUID {
            return Firebase(url: self.firebaseRefURL).childByAppendingPath(currentUserData!.uid)
//        }
        
//        return nil
    }
    
    private func getCurrentUserLocationRef() -> Firebase? {
//        if let currentUserUID = currentUserUID {
            return Firebase(url: self.firebaseRefURL).childByAppendingPath("locations").childByAppendingPath(currentUserData!.uid)
//        }
        
//        return nil
    }
    
    private func getUserLocationRef(uid: String) -> Firebase {
        return Firebase(url: self.firebaseRefURL).childByAppendingPath("locations").childByAppendingPath(uid)
    }
    
    private func getFirebaseMessagesRef() -> Firebase {
        return Firebase(url: self.firebaseRefURL).childByAppendingPath("messages")
    }
    
//    private func getUserWithUID(uid: String) -> User? {
//        for user in self.users {
//            if user.uid == uid {
//                return user
//            }
//        }
//        
//        return nil
//    }
    
    
    
    
    
    
    
    
    
}