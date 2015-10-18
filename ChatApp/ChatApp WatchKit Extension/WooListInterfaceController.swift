//
//  WooListInterfaceController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 10/9/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import Foundation


protocol WooAddedToMessageDelegate
{
    func wooAddedToMessage(wooObject: Dictionary<String, AnyObject>)
}

class WooListInterfaceController: WKInterfaceController
{
    let wooImageSize: CGFloat = 40
    var woos: [Dictionary<String, AnyObject>] = []
    var wooCategory: String! = "none"
    
    var delegate: WooAddedToMessageDelegate! = nil
    
    @IBOutlet var wooListTable: WKInterfaceTable!
    
    // MARK: - WKInterfaceController methods

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let contextDictionary = context as! Dictionary<String, AnyObject>
        self.delegate = contextDictionary["controller"] as! WooAddedToMessageDelegate

        self.wooCategory = contextDictionary["category"] as! String
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
        self.wooListTable.setNumberOfRows(self.woos.count/2+1, withRowType: "WooListTableRow")
        
        let manager = NetworkingManager.sharedInstance.manager
        var downloadIndex = 0

        for var index = 0; index < self.woos.count; index++ {
            
            var currentWoo = self.woos[index]
            let allWooImageFilenames = currentWoo["orderedImages"] as! [String]
            let firstWooImageFilename = allWooImageFilenames[0]
            
            manager.GET(NetworkingManager.staticFilePathComponent + firstWooImageFilename,
                parameters: nil,
                success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let rowController = self.wooListTable.rowControllerAtIndex(downloadIndex/2) as! WooListTableRow
                        
                        var firstWooImage: UIImage = responseObject as! UIImage
                        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.wooImageSize, height: self.wooImageSize), false, 0.0);
                        firstWooImage.drawInRect(CGRectMake(0, 0, self.wooImageSize, self.wooImageSize))
                        firstWooImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        if (downloadIndex % 2 == 0) {
                            rowController.leftWooButton.setBackgroundImage(firstWooImage)
                        }
                        else {
                            rowController.rightWooButton.setBackgroundImage(firstWooImage)
                        }
                        downloadIndex = downloadIndex + 1

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
        let parameters = ["firstImageOnly": "true"]
        
        manager.GET(Woo.wooPath,
            parameters: parameters,
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
