//
//  ThisWeekModel.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import Foundation

struct Product {
    var name: String?
    var productId: Int?
    var productType: ProductType?
    var moneybox: Double?
    var previousMoneybox: Double?
    var subscriptionAmount: Double?
    var planValue: Double?
    var contributedYTD: Double?
    var transferredInYTD: Double?
    var maxDeposit: Double?
    
    init?(data: [String: Any]) {
        guard
            let product = data["Product"] as? [String: Any],
            let moneybox = data["Moneybox"],
            let subscriptionAmount = data["SubscriptionAmount"],
            let planValue = data["PlanValue"],
            let productType = data["InvestorProductType"] as? String
            else { return }
        
        self.name = product["FriendlyName"] as? String
        self.productId = data["InvestorProductId"] as? Int
        self.productType = ProductType(rawValue: productType)
        self.moneybox = moneybox as? Double
        self.previousMoneybox = data["PreviousMoneybox"] as? Double
        self.subscriptionAmount = subscriptionAmount as? Double
        self.planValue = planValue as? Double
        self.contributedYTD = data["Sytd"] as? Double
        self.transferredInYTD = data["TransferInSytd"] as? Double
        self.maxDeposit = data["MaximumDeposit"] as? Double
    }
    
    static func convertToCurrency(amount: Double?) -> String? {
        guard let amount = amount else { return nil }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en-GB")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        if let formattedAmount = formatter.string(from: amount as NSNumber) {
            return formattedAmount
        }
        return nil
    }
}

enum ProductType: String {
    case isa = "Isa"
    case gia = "Gia"
}
