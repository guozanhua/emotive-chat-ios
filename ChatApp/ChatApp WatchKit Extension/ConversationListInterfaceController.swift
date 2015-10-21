//
//  ConversationListInterfaceController.swift
//  ChatApp
//
//  Created by Spencer Congero on 10/2/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class ConversationListInterfaceController: WKInterfaceController {

    var conversations: [Dictionary<String,AnyObject>] = []
    let friendColors = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.purpleColor()]
    
    @IBOutlet var conversationsTable: WKInterfaceTable!
    
    // MARK: - WKInterfaceController methods
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self._getConversations()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }
    
    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - WKInterfaceTable methods
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("Conversation", context: self.conversations[rowIndex])
    }
    
    func loadTableData()
    {
        self.conversationsTable.setNumberOfRows(self.conversations.count, withRowType: "ConversationsTableRow")
        
        for var index = 0; index < self.conversations.count; ++index {
            var currentConversation = conversations[index]
            let row = conversationsTable.rowControllerAtIndex(index) as! ConversationsTableRow
            var conversationTitle = ""
            if let convTitle = currentConversation["title"] {
                conversationTitle = convTitle as! String
            }
            else {
                var userObjects = currentConversation["userObjects"] as! [Dictionary<String,AnyObject>]
                for var k = 0; k < userObjects.count; ++k {
                    let userObject = userObjects[k]
                    if ((userObject["uuid"] as! String) == UserDefaults.currentUserUuid()!) {
                        userObjects.removeAtIndex(k)
                    }
                }
                for var i = 0; i < userObjects.count; ++i {
                    let userObject = userObjects[i]
                    let firstName = userObject["firstName"] as! String
                    conversationTitle = conversationTitle.stringByAppendingString(firstName)
                    if (i != userObjects.count - 1) {
                        conversationTitle = conversationTitle.stringByAppendingString(", ")
                    }
                }
            }
            row.ConversationLabel.setText(conversationTitle)
        }
    }
    
    // MARK: - Internal methods
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
    
    @IBAction func newMessagePressed()
    {
        WKInterfaceController.reloadRootControllersWithNames(["NewMessage"], contexts: nil)
    }
    
    // MARK: - Private methods
    
    private func _getConversations()
    {
        let manager = NetworkingManager.sharedInstance.manager
        let currentUserUuid = UserDefaults.currentUserUuid()
        
        manager.GET(User.userPath + currentUserUuid! + "/" + User.conversationsPathComponent,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all conversations of user")
                    }
                    else if (successful == true) {
                        self.conversations = jsonResult["conversations"] as! [Dictionary<String, AnyObject>]
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
