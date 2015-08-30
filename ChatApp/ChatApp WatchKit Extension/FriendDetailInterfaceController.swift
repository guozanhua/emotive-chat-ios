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
    //preload images
    let blueImage = UIImage(named: "blueGradient")
    let greenImage = UIImage(named: "greenGradient")
    let owlImage = UIImage(named: "owl")
    
    var emotion = ""
    
    /*
    @IBAction func playAction() {
        emotion = "Happy"
        presentControllerWithName("emotiveSelect", context: emotion)
    }
    @IBAction func pauseAction() {
        emotion = "Sad"
        presentControllerWithName("emotiveSelect", context: emotion)
    }
    */

    @IBOutlet var friendImage: WKInterfaceImage!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        if let friend = context as? String {
            setTitle(friend)
        }
        friendImage.setImage(owlImage)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
