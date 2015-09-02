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
    var fbLogInButton: FBSDKLoginButton!
    var signUpButton: UIButton!
    
    var vc : UIViewController?

    // MARK: - UIViewController methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let bgColor = UIColor(red: bgColorRed, green: bgColorGreen, blue: bgColorBlue, alpha: 1)
        self.view.backgroundColor = bgColor
        
        _addEmailTextField()
        _addPassTextField()
        _addFacebookLogin()
        _addSignUpButton()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
    }
    
    // MARK: - Internal methods
    
    func pressed(sender: UIButton!)
    {
        let vc = SignUpViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - FBSDKLoginButtonDelegate methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            if result.grantedPermissions.contains("email") {
                // Successfully logged in
                self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            }
            else {
                print("fetched user: \(result)")
                let userEmail : String = result.valueForKey("email") as! String
                print(userEmail)
                self.emailTextField.text = userEmail
            }
        })
    }
    
    // MARK: - Private methods
    
    private func _addEmailTextField()
    {
        self.emailTextField = UITextField(frame: CGRect(x: textFieldXPos, y: emailFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.emailTextField.attributedPlaceholder = emailPlaceholder
        self.emailTextField.textColor = UIColor.whiteColor()
        self.emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
    }
    
    private func _addPassTextField()
    {
        self.passTextField = UITextField(frame: CGRect(x: textFieldXPos, y: passFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.passTextField.attributedPlaceholder = passPlaceholder
        self.passTextField.textColor = UIColor.whiteColor()
        self.passTextField.secureTextEntry = true
        self.passTextField.delegate = self
        
        self.view.addSubview(self.passTextField)
    }
    
    private func _addFacebookLogin()
    {
        self.fbLogInButton = FBSDKLoginButton()
        self.fbLogInButton.center = self.view.center
        self.fbLogInButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.fbLogInButton.delegate = self
        
        self.view.addSubview(self.fbLogInButton)
    }
    
    private func _addSignUpButton()
    {
        self.signUpButton = UIButton()
        self.signUpButton.setTitle("Sign Up", forState: .Normal)
        self.signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.signUpButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + signUpYOffset, signUpWidth, signUpHeight)
        self.signUpButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.signUpButton)
    }
}

