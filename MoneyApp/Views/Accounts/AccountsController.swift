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
    
    var products: [Product]? {
        didSet {
            tableView.reloadData()
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
        
        self.showLoadingIndicator()
        NetworkManager.getProducts { [weak self] products in
            self?.hideLoadingIndicator()
            self?.products = products
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
            
            if success {
                strongSelf.navigationController?.popViewController(animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
