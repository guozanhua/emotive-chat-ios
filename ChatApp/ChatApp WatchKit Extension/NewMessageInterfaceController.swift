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
        
        if let image = self.wooToMessage?.images[0] {
            self.selectWooButton.setBackgroundImage(image)
            self.selectWooButton.setTitle("")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }

    override func didDeactivate()
    {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        let manager = NetworkingManager.sharedInstance.manager
        
        var userUuids: [String] = []
        
        for var index = 0; index < self.friendsToMessage.count; index++ {
            userUuids.append(self.friendsToMessage[index]["uuid"]!)
        }
        
        if (userUuids.count > 0) {
            var parameters = [:]
            
            if let wooUuidsString = self.wooToMessage?.uuid {
                parameters = ["userUuids": userUuids, "wooUuid": wooUuidsString]
            }
            else {
                parameters = ["userUuids": userUuids]
            }
            
            manager.POST(Conversation.conversationPath,
                parameters: parameters,
                success: {
                    (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                    if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                        if ((jsonResult["success"] as! String) != "true") {
                            print("Failed to create new conversation")
                        }
                    }
                    else {
                        print("Failed to create new conversation")
                        print("Error: responseObject couldn't be converted to Dictionary")
                    }
                }, failure: {
                    (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
                    print("Failed to create new conversation")
                    let errorMessage = "Error: " + error.localizedDescription
                    print(errorMessage)
                    
                    if let response = dataTask.response as? NSHTTPURLResponse {
                        if (response.statusCode == 401) {
                            NetworkingManager.sharedInstance.credentialStore.clearSavedCredentials()
                        }
                    }
                    
                }
            )
        }
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
