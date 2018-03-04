//
//  AccountTableViewCell.swift
//  MoneyApp
//
//  Created by George Davies on 02/03/2018.
//  Copyright © 2018 GeorgeDavies. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountTypeIcon: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        accountTypeIcon.roundCorners()
    }

    func setup(product: Product) {
        if let productId = product.productId, let colour = Appearance.productColour[productId] {
            accountTypeIcon.backgroundColor = colour
        }
        accountNameLabel.text = product.name
        accountBalanceLabel.text = Product.convertToCurrency(amount: product.planValue)
    }

}
