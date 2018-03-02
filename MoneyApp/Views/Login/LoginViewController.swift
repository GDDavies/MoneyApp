//
//  ViewController.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.text = "test+env12@moneyboxapp.com"
        passwordTextField.text = "Money$$box@107"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - Login
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard
            let emailText = emailTextField.text,
            let passwordText = passwordTextField.text
            else { return }
        
        self.showLoadingIndicator()
        NetworkManager.login(email: emailText, password: passwordText) { [weak self] token in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingIndicator()
            
            if let token = token {
//                UserDefaults.standard.set(token, forKey: loginTokenKey)
                strongSelf.performSegue(withIdentifier: "ShowAccounts", sender: strongSelf)
            } else {
                // Handle login error
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 

    }


}

