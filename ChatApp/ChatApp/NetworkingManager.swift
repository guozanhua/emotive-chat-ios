//
//  NetworkingManager.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/31/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit
import WatchConnectivity

class NetworkingManager: NSObject
{
    
    static let sharedInstance = NetworkingManager()
    
    static let baseURLString = "http://localhost:3003/api"
    static let authenticateURLPathComponent = "authenticate"
    static let staticFilePathComponent = "static/"

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

    func authenticate(email: String!, password: String!, completionClosure:(userUUID: String!, email: String!, firstName: String!, lastName: String!, friends:[String]!) -> ())
    {
        let parameters = ["email": email, "password": password]
        
        self.manager.POST(NetworkingManager.authenticateURLPathComponent,
            parameters: parameters,
            success: {
                (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let authToken = jsonResult["token"] as? String
                    let userUUID = jsonResult["uuid"] as? String
                    let email = jsonResult["email"] as? String
                    let firstName = jsonResult["firstName"] as? String
                    let lastName = jsonResult["lastName"] as? String
                    let friends = jsonResult["friends"] as? [String]
                    
                    self.credentialStore.setAuthToken(authToken)
                    
                    if (authToken != nil && userUUID != nil && email != nil && firstName != nil && lastName != nil) {
                        
                        if (WCSession.defaultSession().reachable == true) {
                            let requestValues = ["type": "auth", "uuid": userUUID, "email": email, "firstName": firstName, "lastName": lastName, "authToken": authToken] as [String: String!]
                            let session = WCSession.defaultSession()
                            
                            session.sendMessage(requestValues,
                                replyHandler: { (reply) -> Void in
                                    let status = reply["status"] as? String
                                    if (status != "success") {
                                        print("User not sucessfully authenticated on watch")
                                    }
                                },
                                errorHandler: { (error: NSError!) -> Void in
                                    let errorMessage = "Error: " + error.localizedDescription
                                    print(errorMessage)
                                }
                            )
                        }
                        
                        completionClosure(userUUID: userUUID, email: email, firstName: firstName, lastName: lastName, friends: friends)
                    }
                }
                else {
                    print("Error: responseObject couldn't be converted to Dictionary")
                }
            }, failure: {
                (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
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

    
    func logout()
    {
        self.credentialStore.clearSavedCredentials()
    }
    
    // MARK: - Private methods
    
    private func _setAuthTokenHeader()
    {
        let authToken = self.credentialStore.authToken()
        if (authToken != nil) {
            self.manager.requestSerializer.setValue(authToken, forHTTPHeaderField: "x-auth-token")
        }
    }

}
