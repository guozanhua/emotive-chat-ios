//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Rahul Madduluri on 8/26/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
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
    var loginButton: UIButton!
    var signUpButton: UIButton!

    // MARK: - UIViewController methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let bgColor = UIColor(red: bgColorRed, green: bgColorGreen, blue: bgColorBlue, alpha: 1)
        self.view.backgroundColor = bgColor
        
        _addEmailTextField()
        _addPassTextField()
        _addLoginButton()
        _addSignUpButton()
    }
    
    // MARK: - Internal methods
    
    func signupPressed(sender: UIButton!)
    {
        let vc = SignUpViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func loginPressed(sender: UIButton!)
    {
        let modalStyle = UIModalTransitionStyle.CrossDissolve
        //let friendVC = FriendSearchViewController()
        
        let tabBarController = TabBarViewController()
                
        tabBarController.modalTransitionStyle = modalStyle
        
        NetworkingManager.sharedInstance.authenticate(self.emailTextField.text, password: self.passTextField.text, completionClosure: {
            (userUUID: String!, email: String!, firstName: String!, lastName: String!, friends: [String]!) in
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(userUUID, forKey: "uuid")
            defaults.setObject(firstName, forKey: "firstName")
            defaults.setObject(lastName, forKey: "lastName")
            defaults.setObject(email, forKey: "email")

            //self.presentViewController(friendVC, animated: true, completion: nil)
            self.presentViewController(tabBarController, animated: true, completion: nil)
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
    
    private func _addLoginButton()
    {
        self.loginButton = UIButton()
        self.loginButton.setTitle("Login", forState: .Normal)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.loginButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + 0.5 * signUpYOffset, signUpWidth, signUpHeight)
        self.loginButton.addTarget(self, action: "loginPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.loginButton)
    }
    
    private func _addSignUpButton()
    {
        self.signUpButton = UIButton()
        self.signUpButton.setTitle("Sign Up", forState: .Normal)
        self.signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.signUpButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + signUpYOffset, signUpWidth, signUpHeight)
        self.signUpButton.addTarget(self, action: "signupPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.signUpButton)
    }
}

