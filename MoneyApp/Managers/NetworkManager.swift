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
    
    static func login(email: String, password: String, completionHandler: @escaping (String?, String?) -> Void) {
        
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
                
                let message = data?["Message"] as? String
                
                completionHandler(accessToken, message)
            })
    }
    
    static func logout(completionHandler: @escaping () -> Void) {
        Alamofire.request("\(baseUrl)/users/logout",
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers)
            .response(completionHandler: { response in
                debugPrint(response)
                
                completionHandler()
            })
    }
    
    static func getProducts(completionHandler: @escaping ([Product], Int?) -> Void) {
        Alamofire.request("\(baseUrl)/investorproduct/thisweek",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
            
            .responseJSON(completionHandler: { response in
                debugPrint(response)
                var tempProductArray = [Product]()
                if let data = response.result.value as? [String: Any],
                    let productsArray = data["Products"] as? [[String: Any]] {
                    for product in productsArray {
                        if let newProduct = Product(data: product) {
                            tempProductArray.append(newProduct)
                        }
                    }
                }
                completionHandler(tempProductArray, response.response?.statusCode)
            })
    }
    
    static func makeOneOffPayment(amount: Int, productId: Int, completionHandler: @escaping (Int?) -> Void) {
        
        let parameters: [String: Any] = [
            "Amount": amount,
            "InvestorProductId": productId]
        
        Alamofire.request("\(baseUrl)/oneoffpayments",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            
            .responseJSON(completionHandler: { response in
                debugPrint(response)
                completionHandler(response.response?.statusCode)
            })
    }
}

struct NetworkError {
    
    static func loginError(status: Int) {
        
    }
    
    static func returnErrorFromStatusCode(_ status: Int) -> String {
        switch status {
        case 401:
            return "Your session has expired. Please login again."
        case 400:
            return "Sorry, it isn't possible to perform that action."
        default:
            return "Uknown error, please try again."
        }
    }
}
