//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 8/28/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    var textFieldXPos: CGFloat = 80
    
    var textFieldWidth: CGFloat = 200
    var textFieldHeight: CGFloat = 40
    
    var firstNameFieldYPos: CGFloat = 200
    var textFieldYOffset: CGFloat = 40
    
    var signUpWidth: CGFloat = 100
    var signUpHeight: CGFloat = 50
    var signUpYOffset: CGFloat = 150
    
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var emailTextField: UITextField!
    var passTextField: UITextField!
    var signUpButton: UIButton!
    
    // MARK: - UIViewController methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
        _addFirstNameTextField()
        _addLastNameTextField()
        _addEmailTextField()
        _addPassTextField()
        _addSignUpButton()
    }
    
    // MARK: - Internal methods
    
    func pressed(sender: UIButton!)
    {
        User.createNewUser(self.firstNameTextField.text!, newLastName: self.lastNameTextField.text!, newEmail: self.emailTextField.text!, newPassword: self.passTextField.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Private methods

    private func _addFirstNameTextField()
    {
        self.firstNameTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let firstNamePlaceholder = NSAttributedString(string: "first name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.firstNameTextField.attributedPlaceholder = firstNamePlaceholder
        self.firstNameTextField.textColor = UIColor.whiteColor()
        self.firstNameTextField.delegate = self
        
        self.view.addSubview(firstNameTextField)
    }
    
    private func _addLastNameTextField()
    {
        self.lastNameTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let lastNamePlaceholder = NSAttributedString(string: "last name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.lastNameTextField.attributedPlaceholder = lastNamePlaceholder
        self.lastNameTextField.textColor = UIColor.whiteColor()
        self.lastNameTextField.delegate = self
        
        self.view.addSubview(lastNameTextField)
    }
    
    private func _addEmailTextField()
    {
        self.emailTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 2*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.emailTextField.attributedPlaceholder = emailPlaceholder
        self.emailTextField.textColor = UIColor.whiteColor()
        self.emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
    }
    
    private func _addPassTextField()
    {
        self.passTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 3*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.passTextField.attributedPlaceholder = passPlaceholder
        self.passTextField.textColor = UIColor.whiteColor()
        self.passTextField.secureTextEntry = true
        self.passTextField.delegate = self
        
        self.view.addSubview(passTextField)
    }
    
    private func _addSignUpButton()
    {
        self.signUpButton = UIButton()
        self.signUpButton.setTitle("Sign Up", forState: .Normal)
        self.signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.signUpButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + signUpYOffset, signUpWidth, signUpHeight)
        self.signUpButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(signUpButton)
    }
}
