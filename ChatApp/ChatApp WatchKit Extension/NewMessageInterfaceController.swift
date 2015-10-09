//
//  NewMessageInterfaceController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 10/9/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class NewMessageInterfaceController: WKInterfaceController
{
    @IBOutlet var selectWooButton: WKInterfaceButton!
    @IBOutlet var friendsMessagedButton: WKInterfaceButton!
    
    // MARK: - WKInterfaceController methods

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate()
    {
        super.willActivate()
    }

    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    // MARK: - Internal methods

    @IBAction func selectWooPressed()
    {
        self.presentControllerWithName("EmotiveSelect", context: nil)
    }
    @IBAction func friendsMessagedPressed()
    {
        self.presentControllerWithName("FriendsList", context: nil)
    }
    @IBAction func cancelPressed()
    {
        WKInterfaceController.reloadRootControllersWithNames(["ConversationList"], contexts: nil)
    }
}
