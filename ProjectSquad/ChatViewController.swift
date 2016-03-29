//
//  ChatViewController.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 3/23/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var messages = [JSQMessage]()
    //
    var groupId = "hardcoded"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squad Chat"
        //
        self.senderDisplayName = "Someone"
        self.senderId = "2"
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Gets existing chat from Firebase
        let ref = Firebase(url: "https://squad-development.firebaseio.com/")
        let chatRef = ref.childByAppendingPath("chat")
        let groupChatRef = chatRef.childByAppendingPath(groupId)
        
        groupChatRef.queryLimitedToLast(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let text = snapshot.value["text"] as? String
            let id = snapshot.value["sender"] as? String
            let name = snapshot.value["senderName"] as? String
            let dateInterval = snapshot.value["date"] as? NSTimeInterval
            let date = NSDate(timeIntervalSince1970: dateInterval!)
            
            let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, text: text)
            self.messages.append(message)
            self.finishReceivingMessage()
        })
        
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
//    func addDemoMessages() {
//        for i in 1...10 {
//            let sender = (i%2 == 0) ? "Server" : self.senderId
//            let messageContent = "Message nr. \(i)"
//            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
//            self.messages += [message]
//        }
//        self.reloadMessagesView()
//    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    func addMessage(id: String, name:String, text: String) -> JSQMessage {
        let message = JSQMessage(senderId: id, displayName: name, text: text)
        return message
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
        senderDisplayName: String!, date: NSDate!) {
            
            let message = addMessage(senderId, name: senderDisplayName, text: text)
            NetManager.sharedManager.addChatMessage(message, groupId: self.groupId)
            
            // 4
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            
            // 5
            finishSendingMessage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}