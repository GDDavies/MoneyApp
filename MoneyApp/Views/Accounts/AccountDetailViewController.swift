//
//  AccountDetailViewController.swift
//  MoneyApp
//
//  Created by George Davies on 03/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currentMoneybox: UILabel!
    @IBOutlet weak var depositAmountTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var weeklySubscriptionLabel: UILabel!
    @IBOutlet weak var contributedYTDLabel: UILabel!
    @IBOutlet weak var transferredYTDLabel: UILabel!
    @IBOutlet weak var annualAllowanceRemainingLabel: UILabel!
    
    var selectedProduct: Product?
    var productUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedProduct?.name
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        depositAmountTextField.setLeftPadding(9)
        depositAmountTextField.delegate = self
        
        addDoneButtonToNumpad()
        reloadAmounts()
    }
    
    private func reloadAmounts() {
        guard
            let selectedProduct = self.selectedProduct,
            let current = Product.convertToCurrency(amount: selectedProduct.moneybox)
            else { return }
        
        OperationQueue.main.addOperation {
            self.currentMoneybox.text = current
            
            if let subAmount = Product.convertToCurrency(amount: selectedProduct.subscriptionAmount) {
                self.weeklySubscriptionLabel.text = subAmount
            }
            if let contributedAmount = Product.convertToCurrency(amount: selectedProduct.contributedYTD) {
                self.contributedYTDLabel.text = contributedAmount
            }
            if let transferredAmount = Product.convertToCurrency(amount: selectedProduct.transferredInYTD) {
                self.transferredYTDLabel.text = transferredAmount
            }
            if let remainingAmount = Product.convertToCurrency(amount: selectedProduct.maxDeposit) {
                self.annualAllowanceRemainingLabel.text = remainingAmount
            }
        }
    }

    @IBAction func confirmDepositPressed(_ sender: UIButton) {
        guard
            let depositText = depositAmountTextField.text,
            let product = self.selectedProduct,
            let productId = product.productId,
            let maxDeposit = product.maxDeposit
            else { return }
        
        if let depositError = TextFieldManager.validate(input: depositText,
                                                        type: .deposit,
                                                        maxDeposit: maxDeposit) {
            
            let alert = AlertView.showAlert(title: "Error", message: depositError)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let deposit = Int(depositText) {
            makeOneOffDeposit(deposit: deposit, productId: productId)
        }
    }
    
    private func makeOneOffDeposit(deposit: Int, productId: Int) {
        NetworkManager.makeOneOffPayment(amount: deposit, productId: productId) { [weak self] responseCode in
            guard let strongSelf = self else { return }
            
            strongSelf.productUpdated = false
            
            if responseCode == 200 {
                strongSelf.getUpdatedProduct()
                let alert = AlertView.showAlert(title: "Deposit Successful", message: "£\(deposit.description) deposited successfully", completionHandler: {
                    if !strongSelf.productUpdated {
                        strongSelf.showLoadingIndicator()
                    }
                })
                strongSelf.present(alert, animated: true, completion: nil)
                strongSelf.depositAmountTextField.text = nil
            } else if responseCode == 401 {
                let alert = AlertView.showLogoutAlert(title: "Session Expires",
                                                      message: "Your session has expired and you will be logged out. Please log back in to continue.",
                                                      completionHandler: {
                                                        AuthManager.logoutUser(vc: strongSelf)
                })
                strongSelf.present(alert, animated: true, completion: nil)
            } else {
                let alert = AlertView.showAlert(title: "Network Error", message: NetworkError.returnErrorFromStatusCode(responseCode ?? 0))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func getUpdatedProduct() {
        NetworkManager.getProducts { [weak self] products, reponseCode in
            guard let strongSelf = self else { return }
            
            strongSelf.productUpdated = true
            strongSelf.hideLoadingIndicator()
            
            strongSelf.selectedProduct = products.first(where: {
                $0.productId == strongSelf.selectedProduct?.productId
            })
            strongSelf.reloadAmounts()
        }
    }
    
    // MARK: - TextField Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text
            else { return true }
 
        let newLength = text.count + string.count - range.length
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet) && newLength <= 5
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currencyLabel.textColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currencyLabel.textColor = .lightGray
    }
    
    private func addDoneButtonToNumpad() {
        
        let numpadToolbar = UIToolbar()
        
        numpadToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: depositAmountTextField, action: #selector(UITextField.resignFirstResponder))
        ]
        numpadToolbar.sizeToFit()
        depositAmountTextField.inputAccessoryView = numpadToolbar
    }

}
