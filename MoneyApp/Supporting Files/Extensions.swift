//
//  Extensions.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {    
    func showLoadingIndicator(label: String? = nil) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = label
        hud.isUserInteractionEnabled = true
    }
    
    func hideLoadingIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension UIImageView {
    func roundCorners() {
        layer.cornerRadius = self.frame.height / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
