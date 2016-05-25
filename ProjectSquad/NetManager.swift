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

class NetManager {
    
    static let sharedManager = NetManager()
    var rootRef = FIRDatabase.database().reference()
    private let firebaseRefURL = "https://squad-development.firebaseio.com/"
    var currentUserData: User?
    var currentSquadData: Squad?
    var locationManager: CLLocationManager?
    
    //Login to facebook, set currentUserData
    func loginWithToken(token: FBSDKAccessToken, completionBlock: (success: Bool, hasUsername: Bool) -> Void) {
        //Enabling disk persistence
        FIRDatabase.database().persistenceEnabled = true
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error{
               print("Error logging in \(error)")
            }else{
                let provider = user?.providerID
                let uid = user?.uid
                let displayName = user?.displayName
                var email = ""
                if let emailData = user?.email{
                    email = emailData
                }
                let profPicURL = user?.photoURL!.absoluteString
                
                self.currentUserData = User(uid: uid!, provider: provider!, displayName: displayName!, email: email, picURL: profPicURL!)
                
                let userRef = self.rootRef.child("users").child(uid!)
                userRef.updateChildValues(self.currentUserData!.returnFBUserDict(), withCompletionBlock:{
                    error, ref in
                    //TODO:CHECK error: completionBlock(success: false, hasUsername: false)
                    ref.observeSingleEventOfType(.Value, withBlock: {
                        snapshot in
                        if snapshot.value!["username"]! == nil {
                            completionBlock(success: true, hasUsername: false)
                        } else {
                        completionBlock(success: true, hasUsername: true)
                        }
                    })
                    }
                )
            }
        }
        
    }
    
    func setCurrentUser(user: User){
        self.currentUserData = user;
    }
    
    func userHasUsername(block: (hasUsername: Bool) -> Void){
        let userRef = rootRef.child("users").child(self.currentUserData!.uid).child("username")
        userRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                block(hasUsername: true)
            }
            else{
                block(hasUsername: false)
            }
        })
    }

    func addFriend(friendID: String, friendUsername: String) {
        let friendsRef = rootRef.child("users").child(currentUserData!.uid).child("friends")
        friendsRef.updateChildValues([friendID: friendUsername],
            withCompletionBlock: { error, ref in
            if let error = error {
                //print("Error sending profile info! \(error)")
            }
        })
    }
    
    //Get current user's friends
    func getFriends(uid: String) {
        let friendsRef = rootRef.child("users").child(uid).child("friends")
        friendsRef.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot)
            }, withCancelBlock: { error in
                //print(error.description)
        })
    }
    
    //Get current user's facebook friends
    func getFacebookFriends(block: (resultDict: NSDictionary) -> Void) {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends?limit=1000", parameters: ["fields": "id, name, location"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            var resultDictionary:NSDictionary!
            
            if error == nil {
                resultDictionary = result as! [String: AnyObject]
                block(resultDict: resultDictionary)
            } else {
                //print("Error Getting Friends \(error)");
            }
        }
    }
    
    //Set current user's username
    func setUsername(username: String, completionBlock: (error: NSError?) -> Void) {
        let ref = rootRef.child("users").child(self.currentUserData!.uid)
        let usernameRef = rootRef.child("usernames")
        ref.updateChildValues(["username": username]) { error, ref in
            usernameRef.updateChildValues([username: self.currentUserData!.uid]) { error, ref in
                completionBlock(error: error)
            }
        }
    }
    
    //Set OneSignal push notification Id
    func setOneSignalId(id: String, completionBlock: (error: NSError?) -> Void){
        let ref = rootRef.child("users").child(self.currentUserData!.uid)
        
        ref.updateChildValues(["oneSignalId": id]) { error, ref in
            completionBlock(error: error)
        }
    }
    
    func checkUserCurrentSquad(completionBlock: (squadId: String) -> Void) {
        let ref = rootRef.child("users").child(self.currentUserData!.uid).child("currentSquad")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                completionBlock(squadId: snapshot.value as! String)
            }
            else{
                completionBlock(squadId: "")
            }
        })
    }
    
    
    //MARK: - Location
    func listenForLocationUpdates(userId: String, block: (location: CLLocation) -> Void) {
        let ref = rootRef.child("locations").child(userId)
//        let geoFire = GeoFire(firebaseRef: ref)
//        
//        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
//            self.processChildAddedAndChanged(geoFire, block: block)
//        })
//        
//        ref.observeEventType(.ChildChanged, withBlock: { snapshot in
//            self.processChildAddedAndChanged(geoFire, block: block)
//        })
    }
    
//    func processChildAddedAndChanged(geoFire: GeoFire, block: (location: CLLocation) -> Void) {
//        geoFire.getLocationForKey("location", withCallback: { (location, error) in
//            if (error != nil) {
//                //print("An error occurred getting the location for \"firebase-hq\": \(error.localizedDescription)")
//            } else if (location != nil) {
//                block(location: location)
////                print("Location for \"firebase-hq\" is [\(location.coordinate.latitude), \(location.coordinate.longitude)]")
//            } else {
//                //print("GeoFire does not contain a location for \"firebase-hq\"")
//            }
//        })
//    }
    
    func updateCurrentLocation(currentLocation: CLLocation) {
//        if let ref = self.getCurrentUserLocationRef() {
//            let geofire = GeoFire(firebaseRef: ref)
//            geofire.setLocation(currentLocation, forKey: "location") { (error: NSError?) -> Void in
//                if (error != nil) {
//                    //print("An error occured: \(error)")
//                } else {
////                    print("Saved location successfully!")
//                }
//            }
//        } else {
//            //print("Could NOT update location. User not authenticated.")
//        }
    }

    func checkUsername(username: String, block: (bool: Bool) -> Void){
        let ref = self.rootRef.child("usernames").child(username)
        ref.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                block(bool: true)
            }else{
                block(bool: false)
            }
        })
    }
    
    func getUserByUID(uid: String, block: (user: User) -> Void){
        let requestsRef = rootRef.child("users").child(uid)
        requestsRef.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot)
            let id = uid
            let displayName = snapshot.value!["displayName"] as! String
            let email = snapshot.value!["email"] as! String
            let picURL = snapshot.value!["picURL"] as! String
            let provider = snapshot.value!["provider"] as! String
            let username = snapshot.value!["username"] as! String
            let returnedUser = User(uid: id, provider: provider, displayName: displayName, email: email, picURL: picURL)
            returnedUser.username = username
            block(user: returnedUser)
        })
        

    }
    
    //Send a squad invite request
    func sendSquadRequest(userId: String, squadId: String, squadName: String) {
        let requestRef = rootRef.child("users").child(userId).child("requests")
        
        requestRef.updateChildValues([squadId: squadName],
            withCompletionBlock: { error, ref in
                if let error = error {
                    print("Error sending profile info! \(error)")
                }
                self.sendPushNotification("You have a new Squad invite!", userId: userId)
            })
    }
    
    //Creates a squad and sends out invite requests
    func setSquad(name: String, startTime: NSDate, endTime: NSDate, description: String, invites: [String: String]) {
        let squadRef = rootRef.child("squads")
        let squad1Ref = squadRef.childByAutoId()
        let membersRef = squad1Ref.child("members")
        
        
        
        let leaderId = self.currentUserData!.uid
        //let leadername = self.currentUserData!.displayName
        let leader = [self.currentUserData!.displayName : self.currentUserData!.uid]
        let squadId = squad1Ref.key
        
        let leaderRef = rootRef.child("users").child(leaderId).child("currentSquad")
        
        self.currentSquadData = Squad(id:squadId, name: name, startTime: startTime, endTime: endTime, description: description, leaderId: leaderId, members: leader)
        
        
        squad1Ref.setValue(self.currentSquadData?.returnSquadDict(), withCompletionBlock: { error, ref in
                if let error = error {
                    print("Error sending profile info! \(error)")
                } else{
                    //If no error with setting squad, set members of squad
                    membersRef.setValue(leader ,
                        withCompletionBlock: { error, ref in
                            leaderRef.setValue(squadId)
                        if let error = error {
                            print("Error sending profile info! \(error)")
                        }
                    })
            }
        })
        self.currentUserData?.currentSquad = squadId
        for(inviteeName, inviteeId) in invites{
            sendSquadRequest(inviteeId, squadId: squadId, squadName: name)
        }

    }
    
    func inviteMore(invites: [String: String]) {
        let squadId = self.currentUserData?.currentSquad
        let name = self.currentSquadData?.name
        for(inviteeName, inviteeId) in invites{
            sendSquadRequest(inviteeId, squadId: squadId!, squadName: name!)
        }
        
    }
    
    //Returns data about a squad from it's ID
    func getSquad(squadId: String, block: (squad: Squad) -> Void) {
        let squadRef = rootRef.child("squads").child(squadId)
 
        squadRef.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot)
            let squadName = snapshot.value!["name"] as! String
            let description = snapshot.value!["description"] as! String
            let startTime = snapshot.value!["startTime"] as! String
            let endTime = snapshot.value!["endTime"] as! String
            let leaderId = snapshot.value!["leader"] as! String
            let startDate = NSDate(timeIntervalSince1970: Double(startTime)!)
            let endDate = NSDate(timeIntervalSince1970: Double(endTime)!)
            let memberRef = squadRef.child("members")
            memberRef.observeEventType(.Value, withBlock: { snapshot in
                //print(snapshot)
                var membersDictionary: [String: String] = [:]
                if let membersDictionary = snapshot.value as? NSDictionary{
                    let squad = Squad(id: squadId, name: squadName, startTime: startDate, endTime: endDate, description: description, leaderId: leaderId, members: membersDictionary as! [String : String])
                    block(squad: squad)
                }
                }, withCancelBlock: { error in
                    //print(error.description)
            })        
            }, withCancelBlock: { error in
                //print(error.description)
        })
    }
    
    //Return current user's squad requests
    func getSquadRequests(block: (resultDict: NSDictionary) -> Void) {
        let requestsRef = rootRef.child("users").child((self.currentUserData?.uid)!).child("requests")
    
        
        requestsRef.observeEventType(.Value, withBlock: { snapshot in
            var resultDictionary: [String: String] = [:]
            if let snapVal = snapshot.value as? NSDictionary{
                for(title, id) in snapVal{
                    resultDictionary[title as! String] = id as? String
                }
            }
            block(resultDict: resultDictionary)
            }, withCancelBlock: { error in
                //print(error.description)
        })
    }
    
    //Add current user to a squad
    func joinSquad(thisSquad: Squad, completionBlock: (error: NSError?) -> Void) {
        let squadId = thisSquad.id
        let squadRef = rootRef.child("squads").child(squadId).child("members")
        let usersRef = rootRef.child("users").child((self.currentUserData?.uid)!)
        let requestsRef = usersRef.child("requests").child(squadId)
        let currentSquadRef = usersRef.child("currentSquad")
        
        squadRef.updateChildValues([(self.currentUserData?.displayName)!: (self.currentUserData?.uid)!]) { (error, ref) -> Void in
            requestsRef.removeValue()
            currentSquadRef.setValue(squadId)
            completionBlock(error: error)
            //TODO: Delete request
        }
        self.currentUserData!.currentSquad = squadId
        self.currentSquadData = thisSquad
    }
    
    //Delete squad request
    func deleteSquadRequest(thisSquad: Squad, completionBlock: (error: NSError?) -> Void) {
        let squadId = thisSquad.id
        let requestsRef = rootRef.child("users").child((self.currentUserData?.uid)!).child("requests").child(squadId)
        
        requestsRef.removeValueWithCompletionBlock({
                (error, ref) in
                completionBlock(error: error)
            })

        self.currentUserData!.currentSquad = nil
        self.currentSquadData = nil
    }
    
    func leaveSquad(completionBlock: (error: NSError?) -> Void) {
        let squadRef = rootRef.child("squads").child(self.currentSquadData!.id).child("members").child(currentUserData!.displayName)
        let currentSquadRef = rootRef.child("users").child((self.currentUserData?.uid)!).child("currentSquad")
        
        squadRef.removeValueWithCompletionBlock({
             (error, ref) -> Void in
            currentSquadRef.removeValueWithCompletionBlock({(error, ref) -> Void in
//                self.currentSquadData = nil
//                self.currentUserData!.currentSquad = nil
                completionBlock(error: error)
                
            })
        })
    }
    
    //Add chat message to Firebase
    func addChatMessage(message: JSQMessage, groupId: String){
        let chatRef = rootRef.child("chat")
        let groupChatRef = chatRef.child(groupId)
        let messageRef = groupChatRef.childByAutoId()
        
        messageRef.setValue([
                "text": message.text,
                "sender": message.senderId,
                "senderName": message.senderDisplayName,
                "date": FIRServerValue.timestamp()
            ], withCompletionBlock: { (error, ref) -> Void in
                if let error = error {
                    //print("Error adding chat message! \(error)")
                }
        })
        
    }
    
    func sendPushNotification(message: String, userId: String){
        //Send push notification
        let userRef = rootRef.child("users").child(userId).child("oneSignalId")
        userRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                let oneSignalId = snapshot.value as! String
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let oneSignal = appDelegate.oneSignal
                oneSignal!.postNotification(["contents": ["en": message], "include_player_ids": [oneSignalId], "ios_badgeCount": "1", "ios_badgeType": "Increase"]);
            }
            else{
                print("No OneSignal Id")
            }
        })
        

    }
//    
//    //MARK: - Helpers
//    private func getFirebaseRef() -> Firebase {
//        return Firebase(url: self.firebaseRefURL)
//    }
//    
//    private func getFirebaseLocationsRef() -> Firebase {
//        return Firebase(url: self.firebaseRefURL).child("locations")
//    }
//    
//    private func getCurrentUserRef() -> Firebase {
////        if let currentUserUID = currentUserUID {
//            return Firebase(url: self.firebaseRefURL).child(currentUserData!.uid)
////        }
//        
////        return nil
//    }
//    
//    private func getCurrentUserLocationRef() -> Firebase? {
////        if let currentUserUID = currentUserUID {
//            return Firebase(url: self.firebaseRefURL).child("locations").child(currentUserData!.uid)
////        }
//        
////        return nil
//    }
//    
//    private func getUserLocationRef(uid: String) -> Firebase {
//        return Firebase(url: self.firebaseRefURL).child("locations").child(uid)
//    }
//    
//    private func getFirebaseMessagesRef() -> Firebase {
//        return Firebase(url: self.firebaseRefURL).child("messages")
//    }
//    

    
    
    
    
    
    
    
    
}