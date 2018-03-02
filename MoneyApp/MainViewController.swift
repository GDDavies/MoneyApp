//
//  MainViewController.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func logoutPressed(_ sender: UIButton) {
        // Forget login
        self.navigationController?.popViewController(animated: true)
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
