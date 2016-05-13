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
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red:1.00, green:0.55, blue:0.60, alpha:1.0))
    var messages = [JSQMessage]()
    var groupId: String?
    
    var image: UIImage?
    var imageDict: [String: UIImageView] = [:]
    var userAvatar: UIImageView?
    var members: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SQUAD CHAT"
        //
        self.senderDisplayName = NetManager.sharedManager.currentUserData!.displayName
        self.senderId = NetManager.sharedManager.currentUserData!.uid
        
        groupId = NetManager.sharedManager.currentSquadData!.id

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
//        // No avatars
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        //No attachment
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: self.title!)
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        //containerView.userInteractionEnabled = true
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.backToMap))
        
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChatViewController.backToMap))
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.titleView?.userInteractionEnabled = true
        self.navigationItem.titleView?.addGestureRecognizer(backTap)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        NetManager.sharedManager.getSquad(NetManager.sharedManager.currentSquadData!.id, block: {
            squad in
            for(name, id) in squad.members{
                self.members.append(id)
                NetManager.sharedManager.getUserByUID(id, block: {
                    user in
                    self.imageDict[user.uid] = UIImageView()
                    self.imageDict[user.uid]!.kf_setImageWithURL(NSURL(string: user.picURL)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
                        self.image = image
                        self.reloadMessagesView()
                    })
                })
            }
        })
        
    }
    
    func backToMap(){
        self.performSegueWithIdentifier("backToMapSegue", sender: self)
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
        let senderId = self.messages[indexPath.row].senderId
        if((self.imageDict[senderId]) != nil){
            self.image = self.imageDict[senderId]?.image
        }
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
            NetManager.sharedManager.addChatMessage(message, groupId: self.groupId!)
        
            for member in members{
                if(member != NetManager.sharedManager.currentUserData!.uid){
                    NetManager.sharedManager.sendPushNotification(text, userId: member)
                }
            }
        
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