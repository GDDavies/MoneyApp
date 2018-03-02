//
//  AccountTableViewCell.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountTypeIcon: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(product: Product) {
        accountNameLabel.text = product.name
        accountBalanceLabel.text = "£\(product.planValue?.description)"
    }

}
