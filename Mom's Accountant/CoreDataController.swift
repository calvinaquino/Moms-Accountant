//
//  CoreDataController.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/8/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import CoreData

class CoreDataController {
    static let sharedInstance = CoreDataController()
    
    // MARK: - Singleton Convenience
    
    static var context: NSManagedObjectContext {
        get {
            return sharedInstance.persistentContainer.viewContext
        }
    }
    
    static func saveContext() {
        sharedInstance.saveContext()
    }
    
    static func newTransaction() -> Transaction {
        return Transaction(context: context)
    }
    
    static func deleteTransaction(_ transaction: Transaction) {
        context.delete(transaction)
    }
    
    static func getTransactions(fromYear year: Int?, andMonth month: Int?) -> [Transaction] {
        var transactions: [Transaction]?
        do {
            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            var predicates: [NSPredicate] = []
            if let year = year {
                let yearString = String(year)
                predicates.append(NSPredicate(format: "year == %@", yearString))
            }
            if let month = month {
                let monthString = String(month)
                predicates.append(NSPredicate(format: "month == %@", monthString))
            }
            
            if predicates.count > 0 {
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            }
            
            try transactions = context.fetch(fetchRequest)
        } catch {
            print("fetch failed")
        }
        
        return transactions!
    }
    
    static func getTotalValue(fromYear year: Int?, andMonth month: Int?) -> Float {
        let transactions: [Transaction] = getTransactions(fromYear: year, andMonth: month)
        var total: Float = 0
        for transaction in transactions {
            total += transaction.valueForSum
        }
        
        return total
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Mom_s_Accountant")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
