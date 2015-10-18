//
//  NewMessageInterfaceController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 10/9/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class NewMessageInterfaceController: WKInterfaceController, FriendAddedToMessageDelegate, WooAddedToMessageDelegate
{
    @IBOutlet var selectWooButton: WKInterfaceButton!
    @IBOutlet var friendsMessagedButton: WKInterfaceButton!
    
    var friendsMessagedButtonText: String! = "Add Friend"
    
    var friendsToMessage: [Dictionary<String, String>] = []
    var wooToMessage: Woo? = nil
    
    // MARK: - WKInterfaceController methods

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate()
    {
        super.willActivate()
        
        self.friendsMessagedButton.setTitle(friendsMessagedButtonText)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }

    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    // MARK: - FriendAddedToMessageDelegate methods
    
    func friendAddedToMessage(friendObject: Dictionary<String, String>)
    {
        self.friendsToMessage.append(friendObject)
        if (self.friendsToMessage.count == 1) {
            let newAddFriendsText: String! = friendObject["firstName"]! + " " + friendObject["lastName"]!
            self.friendsMessagedButtonText = newAddFriendsText
        }
        else {
            var initalsList: [String] = []
            for var friend in self.friendsToMessage {
                let firstName: String! = friend["firstName"]
                let lastName: String! = friend["lastName"]
                let firstInitial: String! = firstName.substringToIndex(firstName.startIndex.advancedBy(1))
                let lastInitial: String! = lastName.substringToIndex(lastName.startIndex.advancedBy(1))
                initalsList.append(firstInitial+lastInitial)
            }
            var newAddFriendsText: String! = ""
            for var index = 0; index < initalsList.count; index++ {
                newAddFriendsText = newAddFriendsText + initalsList[index]
                if (index != initalsList.count - 1) {
                    newAddFriendsText = newAddFriendsText + ", "
                }
            }
            self.friendsMessagedButtonText = newAddFriendsText
        }
    }
    
    // MARK: - WooAddedToMessageDelegate methods
    
    func wooAddedToMessage(wooObject: Dictionary<String, AnyObject>)
    {
        let uuidString = wooObject["uuid"] as? String
        let images = wooObject["images"] as! [UIImage]
        
        let woo = Woo()
        woo.uuid = uuidString
        woo.images = images
        self.wooToMessage = woo
        
        let firstImage = images[0]
        self.selectWooButton.setBackgroundImage(firstImage)
    }

    
    // MARK: - Internal methods

    @IBAction func sendWooPressed()
    {
        
    }
    
    @IBAction func selectWooPressed()
    {
        self.presentControllerWithName("EmotiveSelect", context: self)
    }
    @IBAction func friendsMessagedPressed()
    {
        self.presentControllerWithName("FriendsList", context: self)
    }
    @IBAction func cancelPressed()
    {
        WKInterfaceController.reloadRootControllersWithNames(["ConversationList"], contexts: nil)
    }
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
}
