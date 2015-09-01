//
//  User.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/30/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class User: NSObject {

    static var baseURL = "www.woomiapp.com/users/"
    
    var uuid: String?
    var nickname: String?
    var fullName: String?
    var friends: [String]?
    
    // MARK: - Initializers
    
    init(newUUID: String) {
        super.init()
        User.fetchInfoForUser(self, uuid: newUUID)
    }

    init(newNickname: String, newFullName: String, newPassword: String) {
        super.init()
        
        let urlString = User.baseURL.stringByAppendingString("new")
        let manager = NetworkingManager.sharedInstance.manager
        let parameters = ["nickname": newNickname, "fullName": newFullName, "password": newPassword]
        
        manager.POST(urlString,
            parameters: parameters,
            success: {
                (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    self.uuid = jsonResult["uuid"] as? String
                    self.nickname = jsonResult["nickname"] as? String
                    self.fullName = jsonResult["fullName"] as? String
                    self.friends = jsonResult["friends"] as? [String]
                }
                else {
                    print("Error: responseObject coudln't be converted to Dictionary")
                }
            }, failure: {
                (dataTask: NSURLSessionDataTask!, error: NSError!) -> Void in
                let errorMessage = "Error: " + error.localizedDescription
                print(errorMessage)
            }
        )
    }
    
    // MARK: - Type methods
    
    class func fetchInfoForUser(user: User, uuid: String) {
        let urlString = User.baseURL.stringByAppendingString(uuid)
        let manager = NetworkingManager.sharedInstance.manager
        
        manager.GET( urlString,
            parameters: nil,
            success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) in
                if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                    user.uuid = jsonResult["uuid"] as? String
                    user.nickname = jsonResult["nickname"] as? String
                    user.fullName = jsonResult["fullName"] as? String
                    user.friends = jsonResult["friends"] as? [String]
                }
                else {
                    print("Error: responseObject coudln't be converted to Dictionary")
                }
            },
            failure: { (dataTask: NSURLSessionDataTask!, error: NSError!) in
                let errorMessage = "Error: " + error.localizedDescription
                print(errorMessage)
            }
        )
    }
}
