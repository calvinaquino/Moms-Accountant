//
//  ViewController.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/8/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {
    var tableView: UITableView!
    var totalBarItem: TotalBarItem!
    var transactions: [Transaction] = []
    let kCellIdentifier = "kCellIdentifier"
    var year: Int = 0
    var month: Int = 0
    weak var transactionDelegate: TransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transações"
        
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTransactions(reloadData: true)
    }
    
    
    func configureSubviews() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newTransaction))
        
        self.navigationController?.isToolbarHidden = false
        totalBarItem = TotalBarItem(title: "R$0.00", style: .done, target: nil, action: nil)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [flexible, totalBarItem]
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountingTableViewCell.self, forCellReuseIdentifier:AccountingTableViewCell.identifier)
        
        self.view.addSubview(tableView)
        _ = tableView.superAnchor(self.view)
    }
    
    func newTransaction() {
        showTransactionView(nil)
    }
    
    func showTransactionView(_ transacion: Transaction?) {
        let transactionViewController = TransactionViewController()
        if let transaction = transacion {
            transactionViewController.transaction = transaction
            transactionViewController.month = transaction.monthNumber
            transactionViewController.year = transaction.yearNumber
        } else {
            transactionViewController.month = month
            transactionViewController.year = year
        }
        let navigationController = UINavigationController(rootViewController: transactionViewController)
        self.navigationController?.present(navigationController, animated: true, completion: {
            self.refreshTransactions(reloadData: true)
        })
    }
    
    func refreshTransactions(reloadData: Bool) {
        transactions = CoreDataController.getTransactions(fromYear: year, andMonth: month)
        calculateAndShowTotalValue()
        if reloadData {
            tableView.reloadData()
        }
        if let transactionDelegate = transactionDelegate {
            transactionDelegate.didUpdateTransactions(self)
        }
    }
    
    func calculateAndShowTotalValue() {
        var total: Float = 0
        for transaction in transactions {
            total += transaction.valueForSum
        }
        
        totalBarItem.isPayment = total < 0
        totalBarItem.value = abs(total)
    }
}

//MARK - UITableViewDelegate, UITableViewDataSource
extension MonthViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountingTableViewCell.identifier) as! AccountingTableViewCell
        
        let transaction = transactions[indexPath.row]
        cell.textLabel?.text = transaction.name
        cell.detailTextLabel?.text = transaction.stringCurrencyValue()
        cell.setValueStyle(transaction.valueStyle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            let transaction = self.transactions[indexPath.row]
            self.showTransactionView(transaction)
            self.tableView.setEditing(false, animated: true)
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            let transaction = self.transactions[indexPath.row]
            CoreDataController.deleteTransaction(transaction)
            CoreDataController.saveContext()
            self.refreshTransactions(reloadData: false)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        return [deleteAction, editAction]
    }
}

protocol TransactionDelegate: class {
    func didUpdateTransactions(_ viewController: UIViewController)
}

