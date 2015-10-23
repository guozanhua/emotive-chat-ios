//
//  EmotiveSelectInterfaceController.swift
//  ChatApp
//
//  Created by Spencer Congero on 8/29/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class EmotiveSelectInterfaceController: WKInterfaceController {

    @IBOutlet var leftButton: WKInterfaceButton!
    @IBOutlet var rightButton: WKInterfaceButton!
    
    let favoritesTitle: String! = "Favorites"
    
    var newMessageController: NewMessageInterfaceController? = nil
    var newConversationController: ConversationInterfaceController? = nil
    
    // MARK: - WKInterfaceController methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        if let controller = context as? NewMessageInterfaceController {
            self.newMessageController = controller
            self.newConversationController = nil
        }
        else if let controller = context as? ConversationInterfaceController {
            self.newConversationController = controller
            self.newMessageController = nil
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Internal methods

    @IBAction func recentsPressed()
    {
        var contextDictionary = Dictionary<String, AnyObject>()
        contextDictionary["category"] = self.favoritesTitle
        if (self.newMessageController == nil) {
            contextDictionary["controller"] = self.newConversationController
        }
        else {
            contextDictionary["controller"] = self.newMessageController
        }
        self.presentControllerWithName("WooList", context: contextDictionary)
    }
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
}
