//
//  AccountDetailViewController.swift
//  MoneyApp
//
//  Created by George Davies on 03/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController {

    @IBOutlet weak var depositAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmDepositPressed(_ sender: UIButton) {
        NetworkManager.makeOneOffPayment(amount: 20, productId: 3205) { [weak self] responseCode in
            guard let strongSelf = self else { return }
            
            if responseCode == 401 {
                let alert = AlertView.showLogoutAlert(title: "Session Expires",
                                                      message: "Your session has expired and you will be logged out. Please log back in to continue.",
                                                      completion: {
                                                        AuthManager.logoutUser(vc: strongSelf)
                })
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
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
