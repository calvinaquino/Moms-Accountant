//
//  MonthsViewController.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

class MonthsViewController: UIViewController {
    var tableView: UITableView!
    let kCellIdentifier = "kCellIdentifier"
    var year: Int = CalendarHelper.yearNumberFromDate(Date())
    var currentYearButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meses"
        
        configureSubviews()
    }
    
    
    func configureSubviews() {
        let yearString = String(year)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: yearString, style: .plain, target: self, action: nil)
        
        self.navigationController?.isToolbarHidden = false
        
        let previousYearButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(previousYear))
        let flexSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        currentYearButton = UIBarButtonItem(title: yearString, style: .done, target: self, action: nil)
        let flexSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextYearButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(nextYear))
        
        self.toolbarItems = [previousYearButton, flexSpaceLeft, currentYearButton, flexSpaceRight, nextYearButton]
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountingTableViewCell.self, forCellReuseIdentifier:AccountingTableViewCell.identifier)
        
        self.view.addSubview(tableView)
        _ = tableView.superAnchor(self.view)
    }
    
    func nextYear() {
        year += 1
        let yearString = String(year)
        currentYearButton.title = yearString
        tableView.reloadData()
    }
    
    func previousYear() {
        year -= 1
        let yearString = String(year)
        currentYearButton.title = yearString
        tableView.reloadData()
    }
    
    func valueStyle(forValue value: Float) -> ValueStyle {
        if value > 0 {
            return .positive
        } else if value < 0 {
            return .negative
        } else {
            return .zero
        }
    }
    
    func populateMonthsForYear(_ year: Int) {
        
    }
}

//MARK - UITableViewDelegate, UITableViewDataSource
extension MonthsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12//
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountingTableViewCell.identifier) as! AccountingTableViewCell
        
        cell.textLabel?.text = CalendarHelper.monthNameFromNumber(indexPath.row).capitalized
        let value = CoreDataController.getTotalValue(fromYear: year, andMonth: indexPath.row)
        cell.detailTextLabel?.text = AccountingHelper.monetaryValue(fromNumber: value)
        cell.setValueStyle(valueStyle(forValue: value))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthViewController = MonthViewController()
        monthViewController.year = year
        monthViewController.month = indexPath.row
        monthViewController.transactionDelegate = self
        self.navigationController?.pushViewController(monthViewController, animated: true)
    }
}

//MARK: - TransactionDelegate
extension MonthsViewController: TransactionDelegate {
    func didUpdateTransactions(_ viewController: UIViewController) {
        tableView.reloadData()
    }
}
