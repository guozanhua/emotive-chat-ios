//
//  WooListInterfaceController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 10/9/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


class WooListInterfaceController: WKInterfaceController
{
    var woos: [Dictionary<String, AnyObject>] = []
    var wooCategory: String! = "none"
    
    @IBOutlet var wooListTable: WKInterfaceTable!
    
    // MARK: - WKInterfaceController methods

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        self.wooCategory = context as! String
        self._getWoos()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }

    override func willActivate()
    {
        super.willActivate()
    }

    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
    // MARK: - WKInterfaceTable methods
    
    func loadTableData()
    {
        self.wooListTable.setNumberOfRows(self.woos.count/2, withRowType: "WooListTableRow")
        
        for var index = 0; index < woos.count; index++ {
            var currentWoo = self.woos[index]
            let allWooImages = currentWoo["orderedImages"] as! [UIImage]
            let firstWooImage = allWooImages[0]
            let rowController = self.wooListTable.rowControllerAtIndex(index/2) as! WooListTableRow
            if (index % 2 == 0) {
                rowController.leftWooButton.setBackgroundImage(firstWooImage)
            }
            else {
                rowController.rightWooButton.setBackgroundImage(firstWooImage)
            }
        }
    }

    // MARK: - Internal methods
    
    @IBAction func wooButtonPressed()
    {
        self.dismissController()
    }
    
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func _getWoos()
    {
        let manager = NetworkingManager.sharedInstance.manager
        
        manager.GET(Woo.wooPath,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to get all woos")
                    }
                    else if (successful == true) {
                        self.woos = jsonResult["woos"] as! [Dictionary<String, AnyObject>]
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
