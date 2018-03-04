//
//  TextFieldManager.swift
//  MoneyApp
//
//  Created by George Davies on 03/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import Foundation

struct TextFieldManager {
    
    static func validate(input: String?, type: TextFieldType, maxDeposit: Double? = nil) -> String? {
        
        guard let input = input else { return nil }
        
        switch type {
        case .email:
            if input.isEmpty {
                return "Please enter an email address"
            } else {
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                if !NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: input) {
                    return "Please enter a valid email address"
                }
            }
        case .password:
            if input.isEmpty || input.count < 8 {
                return "Please enter a password containing at least 8 characters"
            }
        case .deposit:
            if input.isEmpty {
                return "Please enter a deposit amount"
            } else if let amount = Double(input), let max = maxDeposit, amount > max,
            let maxString = Product.convertToCurrency(amount: max) {
                return "Maximum deposit is \(maxString) - please enter an amount less than this"
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
