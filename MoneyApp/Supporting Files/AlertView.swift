//
//  AlertView.swift
//  MoneyApp
//
//  Created by George Davies on 03/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

struct AlertView {
    static func showAlert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    static func showLogoutAlert(title: String, message: String?, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            guard let completion = completion else { return }
            completion()
        }
        alert.addAction(logoutAction)
    
        return alert
    }
}
