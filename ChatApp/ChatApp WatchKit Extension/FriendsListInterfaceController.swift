//
//  FriendsListInterfaceController.swift
//  ChatApp WatchKit Extension
//
//  Created by Rahul Madduluri on 8/26/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation

protocol FriendAddedToMessageDelegate
{
    func friendAddedToMessage(friendObject: Dictionary<String, String>)
}

class FriendsListInterfaceController: WKInterfaceController
{
    @IBOutlet var friendsTable: WKInterfaceTable!
    
    var friends: [Dictionary<String,String>] = []
    let friendColors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.purpleColor()]
    
    var delegate: FriendAddedToMessageDelegate! = nil
    
    // MARK: - WKInterfaceController methods

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.delegate = context as! FriendAddedToMessageDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self._getFriends()
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - WKInterfaceTable methods
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int)
    {
        self.delegate.friendAddedToMessage(self.friends[rowIndex])
        self.dismissController()
    }
    
    func loadTableData()
    {
        friendsTable.setNumberOfRows(friends.count, withRowType: "FriendsTableRow")
        
        for var index = 0; index < friends.count; ++index {
            let row = friendsTable.rowControllerAtIndex(index) as! FriendsTableRow
            row.friendLabel.setText(friends[index]["firstName"]! + " " + friends[index]["lastName"]!)
            row.friendSeparator.setColor(friendColors[index])
        }
    }
    
    // MARK: - Internal methods
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func _getFriends()
    {
        let manager = NetworkingManager.sharedInstance.manager
        let currentUserUuid = UserDefaults.currentUserUuid()
        
        manager.GET(User.userPath + currentUserUuid! + "/" + User.friendsPathComponent,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all friends of user")
                    }
                    else if (successful == true) {
                        self.friends = jsonResult["friends"] as! [Dictionary<String, String>]
                        
                        self.loadTableData()
                    }
                }
                else {
                    print("Error: responseObject couldn't be converted to Dictionary")
                }
            },
            failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) in
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
