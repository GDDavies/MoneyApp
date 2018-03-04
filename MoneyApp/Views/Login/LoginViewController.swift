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
    
    // MARK: - Login
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard
            let emailText = emailTextField.text,
            let passwordText = passwordTextField.text
            else { return }
        
        var validateError: String?
        
        if let emailError = TextFieldManager.validate(input: emailText, type: .email) {
            validateError = emailError
        } else if let passwordError = TextFieldManager.validate(input: passwordText, type: .password) {
            validateError = passwordError
        }
        if let error = validateError {
            let alert = AlertView.showAlert(title: "Error", message: error)
            self.present(alert, animated: true, completion: nil)
            return
        }
        login(email: emailText, password: passwordText)
    }
    
    private func login(email: String, password: String) {
        showLoadingIndicator()
        NetworkManager.login(email: email, password: password) { [weak self] token, message in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingIndicator()
            
            if token != nil {
                strongSelf.performSegue(withIdentifier: "ShowAccounts", sender: strongSelf)
            } else {
                let alert = AlertView.showAlert(title: "Error",
                                                message: message ?? "An unexpected error has occurred, please try again.")
                strongSelf.present(alert, animated: true, completion: nil)
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

}

