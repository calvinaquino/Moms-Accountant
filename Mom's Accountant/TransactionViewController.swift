//
//  TransactionViewController.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
    var transaction: Transaction?
    var year: Int?
    var month: Int?
    
    private var transactionNameField: TransacionTextField!
    private var transactionValueField: TransacionTextField!
    private var transactionTypeSelector: PaymentTypeControl!
    private var subsequentMonthsStepper: UIStepper!
    private var subsequentMonthsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Nova Transação"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(commitTransaction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelTransaction))
        
        configureSubviews()
    }
    
    func configureSubviews() {
        transactionTypeSelector = PaymentTypeControl()
        transactionTypeSelector.translatesAutoresizingMaskIntoConstraints = false
        
        transactionNameField = TransacionTextField()
        transactionNameField.placeholder = "Nome da transação"
        
        transactionValueField = TransacionTextField()
        transactionValueField.placeholder = "Valor da transação"
        transactionValueField.keyboardType = .decimalPad
        transactionValueField.autocorrectionType = .no
        
        subsequentMonthsStepper = UIStepper()
        subsequentMonthsStepper.translatesAutoresizingMaskIntoConstraints = false
        subsequentMonthsStepper.minimumValue = 1
        subsequentMonthsStepper.maximumValue = 24
        subsequentMonthsStepper.stepValue = 1
        subsequentMonthsStepper.addTarget(self, action: #selector(stepperValueDidChange), for: .valueChanged)
        
        subsequentMonthsLabel = UILabel()
        subsequentMonthsLabel.translatesAutoresizingMaskIntoConstraints = false
        subsequentMonthsLabel.textAlignment = .right
        subsequentMonthsLabel.contentMode = .center
        stepperValueDidChange()
        
        view.addSubview(transactionTypeSelector)
        view.addSubview(transactionNameField)
        view.addSubview(transactionValueField)
        view.addSubview(subsequentMonthsStepper)
        view.addSubview(subsequentMonthsLabel)
        
        _ = transactionTypeSelector.topAnchor(topLayoutGuide.bottomAnchor, constant: 20)
        _ = transactionTypeSelector.horizontalAnchors(view, leftConstant: 20, rightConstant: 20)
        _ = transactionTypeSelector.heightAnchor(constant: 44)
        
        _ = transactionNameField.topAnchor(transactionTypeSelector.bottomAnchor, constant: 20)
        _ = transactionNameField.horizontalAnchors(view, leftConstant: 20, rightConstant: 20)
        _ = transactionNameField.heightAnchor(constant: 44)
        
        _ = transactionValueField.topAnchor(transactionNameField.bottomAnchor, constant: 20)
        _ = transactionValueField.horizontalAnchors(view, leftConstant: 20, rightConstant: 20)
        _ = transactionValueField.heightAnchor(constant: 44)
        
        _ = subsequentMonthsStepper.topAnchor(transactionValueField.bottomAnchor, constant: 20)
        _ = subsequentMonthsStepper.leftAnchor(view.leadingAnchor, constant: 20)
        _ = subsequentMonthsStepper.widthAnchor(constant: 100)
        _ = subsequentMonthsStepper.heightAnchor(constant: 44)
        
        _ = subsequentMonthsLabel.centerYAnchor(subsequentMonthsStepper)
        _ = subsequentMonthsLabel.leftAnchor(subsequentMonthsStepper.trailingAnchor, constant: 20)
        _ = subsequentMonthsLabel.rightAnchor(view.trailingAnchor, constant: 20)
        _ = subsequentMonthsLabel.heightAnchor(constant: 44)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let transaction = transaction {
            transactionTypeSelector.isPayment = transaction.isPayment
            transactionNameField.text = transaction.name
            transactionValueField.text = String(transaction.value)
        }
    }
    
    func stepperValueDidChange() {
        let stepperValue = Int(subsequentMonthsStepper.value)
        
        if stepperValue == 1 {
            subsequentMonthsLabel.text = "Apenas neste mês"
        } else {
            subsequentMonthsLabel.text = "Durante \(stepperValue) meses"
        }
        
    }
    
    func displayErrorMessage() {
        makeEmptyLabelsShowRedBorder()
        let alert = UIAlertController(title: "Aviso", message: "Voce não pode deixar campos vazios!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func commitTransaction() {
        guard let transactionName = transactionNameField.text, let transactionValue = transactionValueField.text else {
            displayErrorMessage()
            return
        }
        if transactionName.isEmpty || transactionValue.isEmpty {
            displayErrorMessage()
            return
        }
        
        var editingTransaction: Transaction? = nil
        if transaction != nil {
            editingTransaction = transaction
        } else {
            editingTransaction = CoreDataController.newTransaction()
            editingTransaction?.month = Int16(month!)
            editingTransaction?.year = Int16(year!)
        }
        
        editingTransaction!.name = transactionName
        editingTransaction!.value = Float(transactionValue)!
        editingTransaction!.isPayment = transactionTypeSelector.isPayment
        
        if subsequentMonthsStepper.value > 1 {
            subsequentMonths(forTransaction: editingTransaction!)
        }
        
        CoreDataController.saveContext()
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func subsequentMonths(forTransaction baseTransaction: Transaction) {
        var currentMonth = baseTransaction.monthNumber
        var currentYear = baseTransaction.yearNumber
        let subsequentMonths = Int(subsequentMonthsStepper.value)
        for _ in 1..<subsequentMonths {
           currentMonth += 1
            if currentMonth > 11 {
                currentYear += 1
                currentMonth = 0
            }
            
            let subsequentTransaction = CoreDataController.newTransaction()
            subsequentTransaction.name = baseTransaction.name
            subsequentTransaction.value = baseTransaction.value
            subsequentTransaction.isPayment = baseTransaction.isPayment
            subsequentTransaction.month = Int16(currentMonth)
            subsequentTransaction.year = Int16(currentYear)
        }
    }
    
    func cancelTransaction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func makeEmptyLabelsShowRedBorder() {
        if transactionNameField.text!.isEmpty {
            transactionNameField.shake()
        }
        if transactionValueField.text!.isEmpty {
            transactionValueField.shake()
        }
    }
}
