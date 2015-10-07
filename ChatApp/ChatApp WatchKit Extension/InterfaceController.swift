//
//  InterfaceController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 9/19/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var authenticateLabel: WKInterfaceLabel!
    
    // MARK: - WKInterfaceController methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        authenticateLabel.setText("Auth Woomi\nor perish...")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Internal methods

    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() != nil) {
            WKInterfaceController.reloadRootControllersWithNames(["ConversationList"], contexts: nil)
        }
    }
    
}
