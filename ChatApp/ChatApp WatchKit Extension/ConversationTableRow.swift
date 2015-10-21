//
//  ConversationTableRow.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 10/21/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit

class ConversationTableRow: NSObject
{
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var wooButton: WKInterfaceButton!
    
    // MARK: - Initializers
    
    override init()
    {
        super.init()
        self.nameLabel.setHidden(true)
        self.wooButton.setHidden(true)
    }
    
}
