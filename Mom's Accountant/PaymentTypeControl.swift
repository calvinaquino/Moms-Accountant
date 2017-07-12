//
//  PaymentTypeControl.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

class PaymentTypeControl: UISegmentedControl {
    var isPayment: Bool {
        get {
            return selectedSegmentIndex == 0
        }
        set {
            selectedSegmentIndex = newValue ? 0 : 1
        }
    }
    
    convenience init() {
        self.init(items: ["A Pagar", "A Receber"])
    }
}
