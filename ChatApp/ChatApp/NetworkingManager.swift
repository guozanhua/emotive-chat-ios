//
//  NetworkingManager.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/31/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject {
    
    static let sharedInstance = NetworkingManager()
    static let baseURLString = "www.woomi.com/"

    var manager: AFHTTPSessionManager
    var sessionToken: String?
    
    // MARK: - Initializers
    
    override init() {
        let baseURL = NSURL(string: NetworkingManager.baseURLString)
        manager = AFHTTPSessionManager(baseURL: baseURL)
    }
    
    // MARK: - Internal methods
    
    func replaceSessionToken(newToken: String) {
        sessionToken = newToken
        manager.requestSerializer.setValue(sessionToken, forHTTPHeaderField: "X-Auth-Token")
    }
}
