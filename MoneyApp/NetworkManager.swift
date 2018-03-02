//
//  NetworkManager.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import Foundation
import Alamofire

let loginTokenKey = "MONEYBOX_LOGIN_TOKEN"

struct NetworkManager {
    
    static let baseUrl = "https://api-test00.moneyboxapp.com"
    
    static var headers: HTTPHeaders = ["Content-Type": "application/json",
                                       "AppId": "8cb2237d0679ca88db6464",
                                       "appVersion": "4.0.0",
                                       "apiVersion": "3.0.0"]
    
    static var accessToken: String? {
        didSet {
            if let token = accessToken {
                headers["Authorization"] = "Bearer " + token
            }
        }
    }
    
    static func login(email: String, password: String, completionHandler: @escaping (String?) -> Void) {
        
        let parameters: [String: Any] = [
            "Email": email,
            "Password": password,
            "Idfa":  UUID().uuidString]
        
        Alamofire.request("\(baseUrl)/users/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            
            .responseJSON(completionHandler: { response in
                debugPrint(response)
                
                let data = response.result.value as? [String: Any]
                let sessionData = data?["Session"] as? [String: Any]

                accessToken = sessionData?["BearerToken"] as? String
                completionHandler(accessToken)
            })
    }
    
    static func logout(completionHandler: @escaping (Bool) -> Void) {
        Alamofire.request("\(baseUrl)/users/logout",
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers)
            
            .responseJSON(completionHandler: { response in
                completionHandler(response.response?.statusCode == 200)
            })
    }
    
    static func getProducts(completionHandler: @escaping ([Product]) -> Void) {
        Alamofire.request("\(baseUrl)/investorproduct/thisweek",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
            
            .responseJSON(completionHandler: { response in
                var tempProductArray = [Product]()
                
                if let data = response.result.value as? [String: Any],
                    let productsArray = data["Products"] as? [[String: Any]] {
                    for product in productsArray {
                        if let newProduct = Product(data: product) {
                            tempProductArray.append(newProduct)
                        }
                    }
                }
                completionHandler(tempProductArray)
            })
    }
    
    static func makeOneOffPayment(amount: Decimal, productId: Int, completionHandler: @escaping (Bool) -> Void) {
        
        let parameters: [String: Any] = [
            "Amount": amount,
            "InvestorProductId": productId]
        
        Alamofire.request("\(baseUrl)/oneoffpayments",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            
            .responseJSON(completionHandler: { response in
                completionHandler(response.response?.statusCode == 200)
            })
    }
}
