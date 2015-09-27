//
//  ExtensionDelegate.swift
//  ChatApp WatchKit Extension
//
//  Created by Rahul Madduluri on 8/26/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate
{
    // MARK: - WKExtensionDelegate methods

    func applicationDidFinishLaunching()
    {
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    func applicationDidBecomeActive()
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive()
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    // MARK: - WKSessionDelegate methods
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        
        switch message["type"] as! String {
        case "auth" :
            let email = message["email"] as! String
            let firstName = message["firstName"] as! String
            let lastName = message["lastName"] as! String
            let userUUID = message["uuid"] as! String
            let token = message["authToken"] as! String
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(userUUID, forKey: "uuid")
            defaults.setObject(firstName, forKey: "firstName")
            defaults.setObject(lastName, forKey: "lastName")
            defaults.setObject(email, forKey: "email")
            
            NetworkingManager.sharedInstance.credentialStore.setAuthToken(token)
            
        default:
            replyValues["status"] = "failure"
            break
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let context = applicationContext["type"]
        
        switch context as! String {
        case "logout" :
            User.currentUser?.logout()
        default :
            break;
        }
    }

}
