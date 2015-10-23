//
//  ConversationInterfaceController.swift
//  ChatApp
//
//  Created by Spencer Congero on 8/29/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class ConversationInterfaceController: WKInterfaceController {
    
    let wooImageSize: CGFloat = 40
    var dateFormatter = NSDateFormatter()
    
    @IBOutlet var messagesTable: WKInterfaceTable!
    
    var conversationContext: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var messages: [Dictionary<String,AnyObject>] = []
    
    // MARK: - WKInterfaceController methods
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.conversationContext = context as! Dictionary<String, AnyObject>
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        self._getMessages()
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
    
    // MARK: - WKInterfaceTable methods
        
    func loadTableData()
    {
        let manager = NetworkingManager.sharedInstance.manager
        self.messagesTable.setNumberOfRows(self.messages.count, withRowType: "MessagesTableRow")
        
        for var index = 0; index < self.messages.count; ++index {
            var currentMessage = self.messages[index]
            let wooObject = currentMessage["woo"] as! Dictionary<String, AnyObject>
            let userObject = currentMessage["userObject"] as! Dictionary<String, AnyObject>
            let row = self.messagesTable.rowControllerAtIndex(index) as! MessagesTableRow
            row.wooButton.setHidden(true)

            let firstName = userObject["firstName"] as! String
            let lastName = userObject["lastName"] as! String
            row.nameLabel.setText(firstName + " " + lastName)
            
            let unformattedTime = currentMessage["created_at"] as! String
            let messageTime = self.dateFormatter.dateFromString(unformattedTime)
            let dateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: messageTime!)
            row.timeLabel.setText(String(dateComponents.hour) + ":" + String(dateComponents.minute))
            
            let firstWooImageName = (wooObject["orderedImageFileNames"] as! [String])[0]
            
            manager.GET(NetworkingManager.staticFilePathComponent + firstWooImageName,
                parameters: nil,
                success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        var firstWooImage: UIImage = responseObject as! UIImage
                        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.wooImageSize, height: self.wooImageSize), false, 0.0);
                        firstWooImage.drawInRect(CGRectMake(0, 0, self.wooImageSize, self.wooImageSize))
                        firstWooImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        row.wooButton.setBackgroundImage(firstWooImage)
                        row.wooButton.setHidden(false)
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
    
    // MARK: - Internal methods
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
    
    // MARK: - Private methods

    private func _getMessages()
    {
        let manager = NetworkingManager.sharedInstance.manager
        let conversationUuid = self.conversationContext["uuid"] as! String
        
        manager.GET(Conversation.conversationPath + conversationUuid,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all conversations of user")
                    }
                    else if (successful == true) {
                        self.messages = jsonResult["messages"] as! [Dictionary<String, AnyObject>]
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
