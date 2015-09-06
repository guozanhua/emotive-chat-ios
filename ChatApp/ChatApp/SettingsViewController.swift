//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate
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
    var cancelButton: UIButton!
    var acceptButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.purpleColor()
        
        _addFirstNameTextField()
        _addLastNameTextField()
        _addEmailTextField()
        _addPassTextField()
        _addCancelButton()
        _addAcceptButton()
    }
    
    // MARK: - Internal methods
    
    func cancelPressed(sender: UIButton!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func acceptPressed(sender: UIButton!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - Private methods
    
    private func _addFirstNameTextField()
    {
        let firstName = defaults.stringForKey("firstName");
        
        self.firstNameTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let firstNamePlaceholder = NSAttributedString(string: "first name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.firstNameTextField.attributedPlaceholder = firstNamePlaceholder
        self.firstNameTextField.text = firstName
        self.firstNameTextField.textColor = UIColor.whiteColor()
        self.firstNameTextField.delegate = self
        
        self.view.addSubview(firstNameTextField)
    }
    
    private func _addLastNameTextField()
    {
        let lastName = defaults.stringForKey("firstName");
        
        self.lastNameTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let lastNamePlaceholder = NSAttributedString(string: "last name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.lastNameTextField.attributedPlaceholder = lastNamePlaceholder
        self.lastNameTextField.text = lastName
        self.lastNameTextField.textColor = UIColor.whiteColor()
        self.lastNameTextField.delegate = self
        
        self.view.addSubview(lastNameTextField)
    }
    
    private func _addEmailTextField()
    {
        let email = defaults.stringForKey("firstName");
        
        self.emailTextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 2*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.emailTextField.attributedPlaceholder = emailPlaceholder
        self.emailTextField.text = email
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
    
    private func _addCancelButton()
    {
        self.cancelButton = UIButton()
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.cancelButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + 0.5 * signUpYOffset, signUpWidth, signUpHeight)
        self.cancelButton.addTarget(self, action: "cancelPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(cancelButton)
    }
    private func _addAcceptButton()
    {
        self.acceptButton = UIButton()
        self.acceptButton.setTitle("Accept", forState: .Normal)
        self.acceptButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.acceptButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + signUpYOffset, signUpWidth, signUpHeight)
        self.acceptButton.addTarget(self, action: "acceptPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(acceptButton)
    }
}
