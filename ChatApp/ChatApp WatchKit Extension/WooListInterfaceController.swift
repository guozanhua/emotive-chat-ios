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
    
    var wooButtons: [WKInterfaceButton] = []
    @IBOutlet var woo1: WKInterfaceButton!
    @IBOutlet var woo2: WKInterfaceButton!
    @IBOutlet var woo3: WKInterfaceButton!
    @IBOutlet var woo4: WKInterfaceButton!
    @IBOutlet var woo5: WKInterfaceButton!
    @IBOutlet var woo6: WKInterfaceButton!
    @IBOutlet var woo7: WKInterfaceButton!
    @IBOutlet var woo8: WKInterfaceButton!
    
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
        
        self.wooButtons = [woo1, woo2, woo3, woo4, woo5, woo6, woo7, woo8]
        
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
    
    // MARK: - Internal methods
    
    func loadButtonData()
    {
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
                        var firstWooImage: UIImage = responseObject as! UIImage
                        self.woos[downloadIndex]["fullImages"] = [firstWooImage]
                        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.wooImageSize, height: self.wooImageSize), false, 0.0);
                        firstWooImage.drawInRect(CGRectMake(0, 0, self.wooImageSize, self.wooImageSize))
                        firstWooImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        self.wooButtons[downloadIndex].setBackgroundImage(firstWooImage)
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
    
    @IBAction func woo1Pressed()
    {
        self._wooPressed(0)
    }
    @IBAction func woo2Pressed()
    {
        if (self.woos.count >= 2) {
            self._wooPressed(1)
        }
    }
    @IBAction func woo3Pressed()
    {
        if (self.woos.count >= 3) {
            self._wooPressed(2)
        }
    }
    @IBAction func woo4Pressed()
    {
        if (self.woos.count >= 4) {
            self._wooPressed(3)
        }
    }
    @IBAction func woo5Pressed()
    {
        if (self.woos.count >= 5) {
            self._wooPressed(4)
        }
    }
    @IBAction func woo6Pressed()
    {
        if (self.woos.count >= 6) {
            self._wooPressed(5)
        }
    }
    @IBAction func woo7Pressed()
    {
        if (self.woos.count >= 7) {
            self._wooPressed(6)
        }
    }
    @IBAction func woo8Pressed()
    {
        if (self.woos.count >= 8) {
            self._wooPressed(7)
        }
    }
    
    @objc func tokenChanged(notification: NSNotification)
    {
        if (NetworkingManager.sharedInstance.credentialStore.authToken() == nil) {
            WKInterfaceController.reloadRootControllersWithNames(["InterfaceController"], contexts: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func _wooPressed(wooIndex: Int)
    {
        if (wooIndex <= self.woos.count - 1) {
            let woo = self.woos[wooIndex]
            let uuidString = woo["uuid"] as! String
            let images = woo["fullImages"]
            
            var wooObject = Dictionary<String, AnyObject>()
            wooObject["uuid"] = uuidString
            wooObject["images"] = images
            self.delegate .wooAddedToMessage(wooObject)
            
            WKInterfaceController.reloadRootControllersWithNames(["NewMessage"], contexts: nil)
        }
    }
    
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
                        self.loadButtonData()
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
