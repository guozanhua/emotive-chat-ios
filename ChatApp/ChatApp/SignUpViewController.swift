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
        
        let firstNameTextField: UITextField = UITextField(frame: CGRect(x: 100.0, y: 200.0, width: 200.0, height: 40.0))
        self.view.addSubview(firstNameTextField)
        let firstNamePlaceholder = NSAttributedString(string: "first name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        firstNameTextField.attributedPlaceholder = firstNamePlaceholder
        firstNameTextField.textColor = UIColor.whiteColor()
        
        let lastNameTextField: UITextField = UITextField(frame: CGRect(x: 100.0, y: 240.0, width: 200.0, height: 40.0))
        self.view.addSubview(lastNameTextField)
        let lastNamePlaceholder = NSAttributedString(string: "last name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        lastNameTextField.attributedPlaceholder = lastNamePlaceholder
        lastNameTextField.textColor = UIColor.whiteColor()
        
        let emailTextField: UITextField = UITextField(frame: CGRect(x: 100.0, y: 280.0, width: 200.0, height: 40.0))
        self.view.addSubview(emailTextField)
        let emailPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        emailTextField.attributedPlaceholder = emailPlaceholder
        emailTextField.textColor = UIColor.whiteColor()
        
        let passTextField: UITextField = UITextField(frame: CGRect(x: 100.0, y: 320.0, width: 200.0, height: 40.0))
        self.view.addSubview(passTextField)
        let passPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        passTextField.attributedPlaceholder = passPlaceholder
        passTextField.textColor = UIColor.whiteColor()
        passTextField.secureTextEntry = true

        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.frame = CGRectMake(135, 500, 100, 50)
        signUpButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(signUpButton)
        
    }
    
    func pressed(sender: UIButton!)
    {
        self.view.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* UITextField Delegates
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
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
