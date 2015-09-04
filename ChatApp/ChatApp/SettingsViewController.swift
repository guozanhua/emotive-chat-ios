//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Spencer Congero on 9/4/15.
//  Copyright © 2015 rahulm. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
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
        let firstNameTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let firstNamePlaceholder = NSAttributedString(string: "first name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        firstNameTextField.attributedPlaceholder = firstNamePlaceholder
        firstNameTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(firstNameTextField)
    }
    
    private func _addLastNameTextField()
    {
        let lastNameTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let lastNamePlaceholder = NSAttributedString(string: "last name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        lastNameTextField.attributedPlaceholder = lastNamePlaceholder
        lastNameTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(lastNameTextField)
    }
    
    private func _addEmailTextField()
    {
        let emailTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 2*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        emailTextField.attributedPlaceholder = emailPlaceholder
        emailTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(emailTextField)
    }
    
    private func _addPassTextField()
    {
        let passTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 3*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        passTextField.attributedPlaceholder = passPlaceholder
        passTextField.textColor = UIColor.whiteColor()
        passTextField.secureTextEntry = true
        
        self.view.addSubview(passTextField)
    }
    
    private func _addCancelButton()
    {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + 0.5 * signUpYOffset, signUpWidth, signUpHeight)
        cancelButton.addTarget(self, action: "cancelPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(cancelButton)
    }
    private func _addAcceptButton()
    {
        let acceptButton = UIButton()
        acceptButton.setTitle("Accept", forState: .Normal)
        acceptButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        acceptButton.frame = CGRectMake(self.view.center.x - signUpWidth/2, self.view.center.y + signUpYOffset, signUpWidth, signUpHeight)
        acceptButton.addTarget(self, action: "acceptPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(acceptButton)
    }
}
