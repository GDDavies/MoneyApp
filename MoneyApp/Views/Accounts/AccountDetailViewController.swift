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
    
    var delegate: AccountsDelegate?
    var selectedProduct: Product?
    var productUpdated = false
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedProduct?.name
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logoutUser),
                                               name: Notification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        depositAmountTextField.setLeftPadding(9)
        depositAmountTextField.delegate = self
        
        addDoneButtonToNumpad()
        reloadAmounts()
    }
    
    // MARK: - Update UI
    
    private func reloadAmounts() {
        guard
            let selectedProduct = self.selectedProduct,
            let current = Product.convertToCurrency(amount: selectedProduct.moneybox)
            else { return }
        
        DispatchQueue.main.async() {
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
    
    // MARK: - Deposit methods

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
            
        } else if let deposit = Int(depositText) {
            makeOneOffDeposit(deposit: deposit, productId: productId)
            self.showLoadingIndicator()
        }
    }
    
    private func makeOneOffDeposit(deposit: Int, productId: Int) {
        NetworkManager.makeOneOffPayment(amount: deposit, productId: productId) { [weak self] status in
            guard let strongSelf = self else { return }
            
            strongSelf.hideLoadingIndicator()
            strongSelf.productUpdated = false
            
            if status == 200 {
                strongSelf.getUpdatedProduct()
                let alert = AlertView.showAlert(title: "Deposit Successful", message: "£\(deposit.description) deposited successfully", completionHandler: {
                    if !strongSelf.productUpdated {
                        strongSelf.hideLoadingIndicator()
                    }
                })
                strongSelf.present(alert, animated: true, completion: nil)
                strongSelf.depositAmountTextField.text = nil
            } else {
                let alert = AlertView.showAlert(title: "Error",
                                                message: MoneyAppError.returnErrorFromStatusCode(status),
                                                completionHandler: {
                    if status == 401 {
                        AuthManager.logoutUser(vc: strongSelf)
                    }
                })
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - User methods
    
    @objc private func logoutUser() {
        AuthManager.logoutUser(vc: self)
    }
    
    private func getUpdatedProduct() {
        NetworkManager.getProducts { [weak self] products, status in
            guard let strongSelf = self else { return }
            
            strongSelf.productUpdated = true
            strongSelf.hideLoadingIndicator()
            
            if status == 200 {
                strongSelf.selectedProduct = products.first(where: {
                    $0.productId == strongSelf.selectedProduct?.productId
                })
                strongSelf.reloadAmounts()
                strongSelf.delegate?.productsUpdated(products: products)
            } else {
                let alert = AlertView.showAlert(title: "Error",
                                                message: MoneyAppError.returnErrorFromStatusCode(status),
                                                completionHandler: {
                    if status == 401 {
                        AuthManager.logoutUser(vc: strongSelf)
                    }
                })
                strongSelf.present(alert, animated: true, completion: nil)
            }
            
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
