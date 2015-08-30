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
    
    @IBAction func leftPressed() {
        //dismissController()
    }
    @IBAction func rightPressed() {
        //dismissController()
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        /*
        if let title = context as? String {
            setTitle(title)
        }
        */
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
