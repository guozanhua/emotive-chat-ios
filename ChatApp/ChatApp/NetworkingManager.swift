//
//  NetworkingManager.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/31/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject
{
    
    static let sharedInstance = NetworkingManager()
    
    static let baseURLString = "www.woomiapp.com"
    static let authenticateURLPathComponent = "/login"

    var manager: AFHTTPSessionManager
    var credentialStore : CredentialStore
    
    // MARK: - Initializers
    
    override init()
    {
        let baseURL = NSURL(string: NetworkingManager.baseURLString)
        self.manager = AFHTTPSessionManager(baseURL: baseURL)
        self.credentialStore = CredentialStore()
        
        super.init()
        
        self._setAuthTokenHeader()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("tokenChanged:"), name: "token-changed", object: nil)
    }
    
    // MARK: - Internal methods
    
    @objc func tokenChanged(notification: NSNotification)
    {
        self._setAuthTokenHeader()
    }
    
    func authenticate(username: String!, password: String!)
    {
        let parameters = ["username": username, "password": password]
        
        self.manager.POST(NetworkingManager.authenticateURLPathComponent,
            parameters: parameters,
            success: {
                (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let authToken = jsonResult["auth_token"] as? String
                    self.credentialStore.setAuthToken(authToken)
                }
                else {
                    print("Error: responseObject coudln't be converted to Dictionary")
                }
            }, failure: {
                (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
                let errorMessage = "Error: " + error.localizedDescription
                print(errorMessage)
                
                if let response = dataTask.response as? NSHTTPURLResponse {
                    if (response.statusCode == 401) {
                        NetworkingManager.sharedInstance.credentialStore.setAuthToken(nil)
                    }
                }
                
            }
        )
    }
    
    // MARK: - Private methods
    
    private func _setAuthTokenHeader()
    {
        let authToken = self.credentialStore.authToken()
        self.manager.requestSerializer.setValue(authToken, forHTTPHeaderField: "X-Auth-Token")
    }

}
