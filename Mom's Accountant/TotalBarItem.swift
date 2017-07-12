//
//  TotalBarItem.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

class TotalBarItem: UIBarButtonItem {
    var value: Float = 0.0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let currencyValue = formatter.string(from: value as NSNumber) {
                title = String(currencyValue)
            }
        }
    }
    
    var isPayment: Bool = false {
        didSet {
            if isPayment {
                tintColor = .red
            } else {
                tintColor = .green
            }
        }
    }
}
