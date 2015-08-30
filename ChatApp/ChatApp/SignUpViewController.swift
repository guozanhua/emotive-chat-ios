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

    override func viewDidLoad() {
        super.viewDidLoad()
        //userTextField.delegate = self

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.redColor()
        
        addFirstNameTextField()
        
        addLastNameTextField()
        
        addEmailTextField()
        
        addPassTextField()

        addSignUpButton()
    }
    
    func addFirstNameTextField()
    {
        let firstNameTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos, width: textFieldWidth, height: textFieldHeight))
        let firstNamePlaceholder = NSAttributedString(string: "first name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        firstNameTextField.attributedPlaceholder = firstNamePlaceholder
        firstNameTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(firstNameTextField)
    }
    
    func addLastNameTextField()
    {
        let lastNameTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let lastNamePlaceholder = NSAttributedString(string: "last name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        lastNameTextField.attributedPlaceholder = lastNamePlaceholder
        lastNameTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(lastNameTextField)
    }
    
    func addEmailTextField()
    {
        let emailTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 2*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        emailTextField.attributedPlaceholder = emailPlaceholder
        emailTextField.textColor = UIColor.whiteColor()
        
        self.view.addSubview(emailTextField)
    }
    
    func addPassTextField()
    {
        let passTextField: UITextField = UITextField(frame: CGRect(x: textFieldXPos, y: firstNameFieldYPos + 3*textFieldYOffset, width: textFieldWidth, height: textFieldHeight))
        let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        passTextField.attributedPlaceholder = passPlaceholder
        passTextField.textColor = UIColor.whiteColor()
        passTextField.secureTextEntry = true
        
        self.view.addSubview(passTextField)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
