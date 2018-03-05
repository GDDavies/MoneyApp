//
//  MainViewController.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

protocol AccountsDelegate {
    func productsUpdated(products: [Product]?)
}

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AccountsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logoutPressed(_:)),
                                               name: Notification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        setupNavBar()
        getProducts()
    }
    
    // MARK: - Products
    
    private func getProducts() {
        self.showLoadingIndicator()
        NetworkManager.getProducts { [weak self] products, status in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingIndicator()
            
            if status == 200 {
                strongSelf.products = products
            } else if let status = status {
                let alert = AlertView.showAlert(title: "Error", message: MoneyAppError.returnErrorFromStatusCode(status), completionHandler: {
                    if status == 401 {
                        AuthManager.logoutUser(vc: strongSelf)
                    }
                })
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func productsUpdated(products: [Product]?) {
        self.products = products
    }
    
    // MARK: - Setup UI
    
    private func setupNavBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        let image = UIImage(named:"Logout") as UIImage!
        let btnBack = UIButton(type: .custom)
        btnBack.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
        btnBack.setImage(image, for: .normal)
        btnBack.setTitleColor(.blue, for: .normal)
        btnBack.sizeToFit()
        let myCustomBackButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    @objc private func logoutPressed(_ sender: UIButton) {
        self.showLoadingIndicator()

        NetworkManager.logout {
            self.hideLoadingIndicator()
            AuthManager.logoutUser(vc: self)
        }
    }
    
    // MARK: - TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = self.products {
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountTableViewCell
        if let products = self.products {
            cell.setup(product: products[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AccountDetailViewController,
        let cell = sender as? AccountTableViewCell,
        let indexPath = tableView.indexPath(for: cell) {
            vc.delegate = self
            vc.selectedProduct = products?[indexPath.row]
        }
    }
 
}
