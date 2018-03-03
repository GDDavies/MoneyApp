//
//  AuthManager.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

struct AuthManager {
    static func logoutUser(vc: UIViewController) {
        NetworkManager.accessToken = nil
        vc.navigationController?.popToRootViewController(animated: true)
    }
}


