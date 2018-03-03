//
//  TextFieldManager.swift
//  MoneyApp
//
//  Created by George Davies on 03/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import Foundation

struct TextFieldManager {
    
    static func validate(input: String?, type: TextFieldType) -> String? {
        
        guard let input = input else { return nil }
        
        switch type {
        case .email:
            if input.isEmpty {
                return "Please enter an email address"
            }
        case .password:
            if input.isEmpty || input.count < 8 {
                return "Please enter a password containing at least 8 characters"
            }
        case .deposit:
            if input.isEmpty {
                return "Please enter a deposit amount"
            } else if let amount = Int(input),
            amount > 2000 {
                return "Maximum deposit is £2000, please enter an amount less than this"
            }
        }
        return nil
    }
    
    enum TextFieldType {
        case email
        case password
        case deposit
    }
}
