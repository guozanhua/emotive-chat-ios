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
    var bgColorRed: CGFloat = 0
    var bgColorGreen: CGFloat = 239/255
    var bgColorBlue: CGFloat = 224/255
    
    var textFieldXPos: CGFloat = 80
    
    var emailFieldYPos: CGFloat = 160
    var passFieldYPos: CGFloat = 200
    
    var textFieldWidth: CGFloat = 200
    var textFieldHeight: CGFloat = 40
    
    var signUpWidth: CGFloat = 100
    var signUpHeight: CGFloat = 50
    var signUpYOffset: CGFloat = 150
    
    var emailTextField: UITextField!
    var passTextField: UITextField!
    var signUpButton: UIButton!
    
    var vc : UIViewController?

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
            let bgColor = UIColor(red: bgColorRed, green: bgColorGreen, blue: bgColorBlue, alpha: 1)
            self.view.backgroundColor = bgColor

            addEmailTextField()
            
            addPassTextField()
            
            addFacebookLogin()
            
            addSignUpButton()
        }

    }
    
    func addEmailTextField()
    {
        let emailTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: emailFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        emailTextField.attributedPlaceholder = emailPlaceholder
        emailTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(emailTextField)
    }
    
    func addPassTextField()
    {
        let passTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: passFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        passTextField.attributedPlaceholder = passPlaceholder
        passTextField.textColor = UIColor.whiteColor()
        passTextField.secureTextEntry = true
        
        self.view.addSubview(passTextField)
    }
    
    func addFacebookLogin()
    {
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
        self.view.addSubview(loginView)
    }
    
    func addSignUpButton()
    {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + signUpYOffset, signUpWidth, signUpHeight)
        signUpButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(signUpButton)
    }
    
    func pressed(sender: UIButton!)
    {
        let vc = SignUpViewController()
        self.presentViewController(vc, animated: true, completion: nil)
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

