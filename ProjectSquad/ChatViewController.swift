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
import Kingfisher

class ChatViewController: JSQMessagesViewController {
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var messages = [JSQMessage]()
    //
    var groupId = NetManager.sharedManager.currentSquadData!.id
    
    var image: UIImage?
    var currentUserAvatar: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squad Chat"
        //
        self.senderDisplayName = "Someone"
        self.senderId = "2"
        
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: nil)

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
//        // No avatars
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        let containerView = UIView()
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: self.title!)
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        containerView.frame.size.height = titleLabel.frame.size.height
        containerView.frame.size.width = titleLabel.frame.size.width + titleLabel.frame.size.height
        //containerView.userInteractionEnabled = true
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(Map.toSquadOverview))
        
        containerView.addSubview(titleLabel)
        
        self.navigationItem.titleView = containerView
        self.navigationItem.titleView?.userInteractionEnabled = true
//        self.navigationItem.titleView?.addGestureRecognizer(tap)

        
        currentUserAvatar = UIImageView()
        
        currentUserAvatar!.kf_setImageWithURL(NSURL(string: "https://scontent.xx.fbcdn.net/hprofile-xlf1/v/t1.0-1/p100x100/12743778_10153667545016387_7753665671545921054_n.jpg?oh=d0d4a8b3935b302e362e15daee44e8a2&oe=578077E6")!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
                self.image = image
                self.reloadMessagesView()
        })
        
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
        self.image = self.currentUserAvatar!.image
        if(self.image != nil){
            return JSQMessagesAvatarImage(avatarImage: self.image, highlightedImage: self.image, placeholderImage: self.image)}
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}