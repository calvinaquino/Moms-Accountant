//
//  Transaction+CoreDataProperties.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Float
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    @NSManaged public var isPayment: Bool

}
