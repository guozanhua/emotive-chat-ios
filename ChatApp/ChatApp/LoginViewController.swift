//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/26/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate
{
    var userTextField: UITextField!
    var passTextField: UITextField!

    /* UIViewController overrides */
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //userTextField.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let bgColor = UIColor(red: 0, green: 239/255, blue: 224/255, alpha: 1)
            self.view.backgroundColor = bgColor

            let userTextField: UITextField = UITextField(frame: CGRect(x: 80.0, y: 160.0, width: 200.0, height: 40.0))
            self.view.addSubview(userTextField)
            let userPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
            userTextField.attributedPlaceholder = userPlaceholder
            userTextField.textColor = UIColor.whiteColor()
            
            let passTextField: UITextField = UITextField(frame: CGRect(x: 80.0, y: 200.0, width: 200.0, height: 40.0))
            self.view.addSubview(passTextField)
            let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
            passTextField.attributedPlaceholder = passPlaceholder
            passTextField.textColor = UIColor.whiteColor()
            passTextField.secureTextEntry = true
            
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }

    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    
    /* FBSDKLoginButtonDelegate methods */
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            if result.grantedPermissions.contains("email")
            {
                // Successfully logged in
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }

}

