//
//  NetworkTests.swift
//  MoneyAppTests
//
//  Created by George Davies on 04/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import XCTest
@testable import MoneyApp

class NetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    // MARK: - Login
    
    func testSuccessfulLogin() {
        
        let e = expectation(description: "Alamofire")
        
        // Enter test credentials when testing
        let email = ""
        let password = ""
        
        NetworkManager.login(email: email, password: password) { token, message in
            XCTAssertNotNil(token)
            XCTAssertNil(message)
            
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func testFailedLogin() {
        
        let e = expectation(description: "Alamofire")

        let email = "a@b.cd"
        let password = "12345678"
        
        NetworkManager.login(email: email, password: password) { token, message in
            XCTAssertNil(token)
            XCTAssertNotNil(message)
            
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Authenticated requests
    
    func testGettingProductsWithNoToken() {
        
        let e = expectation(description: "Alamofire")

        NetworkManager.getProducts { products, statusCode in
            XCTAssertTrue(products.count == 0)
            XCTAssertTrue(statusCode == 401)
            
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func testOneOffPaymentNoToken() {
        
        let e = expectation(description: "Alamofire")
        
        NetworkManager.makeOneOffPayment(amount: 10, productId: 3123) { statusCode in
            XCTAssertFalse(statusCode == 200)
            
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
}
