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

    static var userPath = "/users"
    static var newUserPathComponent = "/new"
    static var currentUser : User?
    
    var uuid: String?
    var nickname: String?
    var firstName: String?
    var lastName: String?
    var friends: [String]?
    
    // MARK: - Initializers
    
    init(newUUID: String)
    {
        super.init()
        User.fetchInfoForUser(self, uuid: newUUID)
    }

    init(newNickname: String, newFirstName: String, newLastName: String, newPassword: String)
    {
        super.init()
        
        let urlString = User.userPath.stringByAppendingString(User.newUserPathComponent)
        let manager = NetworkingManager.sharedInstance.manager
        let parameters = ["nickname": newNickname, "firstName": newFirstName, "lastName": newLastName, "password": newPassword]
        
        manager.POST(urlString,
            parameters: parameters,
            success: {
                (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    self.uuid = jsonResult["uuid"] as? String
                    self.nickname = jsonResult["nickname"] as? String
                    self.firstName = jsonResult["firstName"] as? String
                    self.lastName = jsonResult["lastName"] as? String
                    self.friends = jsonResult["friends"] as? [String]
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
    
    // MARK: - Type methods
    
    class func fetchInfoForUser(user: User, uuid: String)
    {
        let urlString = User.userPath.stringByAppendingString(uuid)
        let manager = NetworkingManager.sharedInstance.manager
        
        manager.GET( urlString,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    user.uuid = jsonResult["uuid"] as? String
                    user.nickname = jsonResult["nickname"] as? String
                    user.firstName = jsonResult["firstName"] as? String
                    user.lastName = jsonResult["lastName"] as? String
                    user.friends = jsonResult["friends"] as? [String]
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
