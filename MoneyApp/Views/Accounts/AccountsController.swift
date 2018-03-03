//
//  MainViewController.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyBoxAmountLabel: UILabel!
    
    var products: [Product]? {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getProducts()
    }
    
    private func getProducts() {
        self.showLoadingIndicator()
        NetworkManager.getProducts { [weak self] products, status in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingIndicator()
            if status == 200 {
                strongSelf.products = products
            } else if let status = status {
                NetworkError.returnErrorFromStatusCode(status)
            }
        }
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

//        UserDefaults.standard.set(nil, forKey: loginTokenKey)
        NetworkManager.logout { [weak self] success in
            guard let strongSelf = self else { return }
            
            strongSelf.hideLoadingIndicator()
            AuthManager.logoutUser(vc: strongSelf)

            if success {
                // Logout?
            } else {
                // Unable to logout alert
            }
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
            vc.selectedProduct = products?[indexPath.row]
        }
    }
 
}
