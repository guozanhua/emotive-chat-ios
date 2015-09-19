//
//  FriendsListInterfaceController.swift
//  ChatApp WatchKit Extension
//
//  Created by Rahul Madduluri on 8/26/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class FriendsListInterfaceController: WKInterfaceController
{

    @IBOutlet var friendsTable: WKInterfaceTable!
    
    let friends = ["Rahul", "Spencer", "Jack", "Steve", "Sean"]
    let friendColors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.purpleColor()]
    
    // MARK: - WKInterfaceController methods

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        loadTableData()
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - WKInterfaceTable methods
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        presentControllerWithNames(["FriendDetails", "emotiveSelect"], contexts: [friends[rowIndex], friends[rowIndex]])
    }
    
    func loadTableData()
    {
        friendsTable.setNumberOfRows(friends.count, withRowType: "FriendsTableRow")
        
        for (index, friendName) in friends.enumerate() {
            
            let row = friendsTable.rowControllerAtIndex(index) as! FriendsTableRow
            row.friendLabel.setText(friendName)
            row.friendSeparator.setColor(friendColors[index]);
        }
    }
}
