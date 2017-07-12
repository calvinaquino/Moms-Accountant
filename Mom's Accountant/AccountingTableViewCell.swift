//
//  TransactionTableViewCell.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

enum ValueStyle {
    case zero
    case positive
    case negative
}

class AccountingTableViewCell: UITableViewCell {
    static let identifier = "AccountingTableViewCellReuseIdentifier"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setValueStyle(.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setValueStyle(.zero)
    }
    
    func setValueStyle(_ valueStyle: ValueStyle) {
        if valueStyle == .negative {
            detailTextLabel!.textColor = .red
        } else if valueStyle == .positive {
            detailTextLabel!.textColor = .green
        } else {
            detailTextLabel!.textColor = .lightGray
        }
    }
}
