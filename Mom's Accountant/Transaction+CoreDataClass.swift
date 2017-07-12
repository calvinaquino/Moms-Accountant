//
//  Transaction+CoreDataClass.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/8/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    
    var monthName: String {
        return CalendarHelper.monthNameFromNumber(monthNumber)
    }
    
    var monthNumber: Int {
        return Int(month)
    }
    
    var yearNumber: Int {
        return Int(year)
    }
    
    var valueForSum: Float {
        if isPayment {
            return -value
        } else {
            return value
        }
    }
    
    var valueStyle: ValueStyle {
        let value = valueForSum
        if value > 0 {
            return .positive
        } else if value < 0 {
            return .negative
        } else {
            return .zero
        }
    }
    
    func stringCurrencyValue() -> String {
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
