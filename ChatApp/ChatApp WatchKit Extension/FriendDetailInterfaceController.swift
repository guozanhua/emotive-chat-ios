//
//  FriendDetailInterfaceController.swift
//  ChatApp
//
//  Created by Spencer Congero on 8/29/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class FriendDetailInterfaceController: WKInterfaceController {

    let blueImage = UIImage(named: "blueGradient")
    let greenImage = UIImage(named: "greenGradient")
    let owlImage = UIImage(named: "owl")
    
    var emotion = ""
    
    @IBOutlet var friendImage: WKInterfaceImage!
    
    // MARK: - WKInterfaceController methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        if let friend = context as? String {
            setTitle(friend)
        }
        friendImage.setImage(owlImage)
        
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
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            presentControllerWithName("InterfaceController", context: nil)
        }
    }
}
