//
//  User.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/30/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class User: NSObject
{

    static var userPath = "users/"
    static var friendsPathComponent = "friends/"
    static var currentUser : User?
    
    var uuid: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var friends: [String]?
    
    // MARK: - Initializers
    
    init(newUUID: String)
    {
        super.init()
        User.fetchInfoForUser(self, uuid: newUUID)
    }
    
    // MARK: - Type methods
    
    class func createNewUser(newFirstName: String, newLastName: String, newEmail: String, newPassword: String)
    {
        let manager = NetworkingManager.sharedInstance.manager
        let parameters = ["firstName": newFirstName, "lastName": newLastName, "email": newEmail, "password": newPassword]
        
        manager.POST(User.userPath,
            parameters: parameters,
            success: {
                (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    let successful = jsonResult["success"] as? Bool
                    if (successful == false) {
                        print("Failed to create new user")
                    }
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
    
    class func fetchInfoForUser(user: User, uuid: String)
    {
        let manager = NetworkingManager.sharedInstance.manager
        
        manager.GET(User.userPath + uuid,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    user.uuid = jsonResult["uuid"] as? String
                    user.firstName = jsonResult["firstName"] as? String
                    user.lastName = jsonResult["lastName"] as? String
                    user.email = jsonResult["email"] as? String
                }
                else {
                    print("Error: responseObject coudln't be converted to Dictionary")
                }
            },
            failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) in
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
}
