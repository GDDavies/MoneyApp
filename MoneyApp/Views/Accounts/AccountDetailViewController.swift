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
    @IBOutlet weak var lastWeekMoneybox: UILabel!
    @IBOutlet weak var depositAmountTextField: UITextField!
    
    var selectedProduct: Product?
    var productUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        depositAmountTextField.delegate = self
        addDoneButtonToNumpad()
        reloadAmounts()
    }
    
    private func reloadAmounts() {
        guard
            let selectedProduct = self.selectedProduct,
            let current = Product.convertToCurrency(amount: selectedProduct.moneybox),
            let lastWeek = Product.convertToCurrency(amount: selectedProduct.previousMoneybox)
            else { return }
        
        OperationQueue.main.addOperation {
            self.currentMoneybox.text = current
            self.lastWeekMoneybox.text = lastWeek
        }
    }

    @IBAction func confirmDepositPressed(_ sender: UIButton) {
        guard
            let depositText = depositAmountTextField.text,
            let product = self.selectedProduct,
            let productId = product.productId
            else { return }
        
        if let depositError = TextFieldManager.validate(input: depositText, type: .deposit) {
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
        return allowedCharacters.isSuperset(of: characterSet) && newLength <= 4
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
