//
//  UserDefaults.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 9/15/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class UserDefaults: NSObject {

    // MARK: - Type methods

    class func currentUserUuid () -> String?
    {
        let currentUserUuid = NSUserDefaults.standardUserDefaults().stringForKey("uuid")
        if (currentUserUuid == nil) {
            print("ERROR - could not find current user uuid")
        }
        return currentUserUuid
    }
}
