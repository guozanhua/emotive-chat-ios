//
//  CredentialStore.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 9/1/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class CredentialStore: NSObject
{
    let SERVICE_NAME = "CHAT_CLIENT"
    let AUTH_TOKEN_KEY = "AUTH_TOKEN_KEY"
    
    // MARK: - Internal methods
    
    func isLoggedIn() -> Bool
    {
        if self.authToken() != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func clearSavedCredentials()
    {
        self._setAuthToken(nil)
    }
    
    func authToken() -> String
    {
        return self._secureValueForKey(self.AUTH_TOKEN_KEY)
    }
    
    func setAuthToken(newAuthToken: String)
    {
        self._setSecureValueForKey(newAuthToken, key: AUTH_TOKEN_KEY)
        NSNotificationCenter.defaultCenter().postNotificationName("token-changed", object: self)
    }
    
    // MARK: - Private methods
    
    func _setSecureValueForKey(secureValue: String, key: String!)
    {
        if (secureValue) {
            SSKeychain.setPassword(secureValue, forService: SERVICE_NAME, account: key)
        }
        else {
            SSKeychain.deletePasswordForService(SERVICE_NAME, account: key)
        }
    }
    
    func _secureValueForKey(key: String!) -> String
    {
        return SSKeychain.passwordForService(SERVICE_NAME, account: key)
    }
    
}
