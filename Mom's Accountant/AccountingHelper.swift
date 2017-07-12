//
//  AccountingHelper.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/12/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import Foundation

struct AccountingHelper {
    
    static func monetaryValue(fromNumber value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let currencyValue = formatter.string(from: value as NSNumber) {
            return String(currencyValue)
        } else {
            return "Erro"
        }
    }
}
