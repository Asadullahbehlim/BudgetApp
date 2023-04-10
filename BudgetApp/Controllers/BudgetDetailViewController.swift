//
//  BudgetDetailViewController.swift
//  BudgetApp
//
//  Created by Asadullah Behlim on 10/04/23.
//

import Foundation
import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<Transactions>!
    private var budgetCategory: BudgetCategory
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.placeholder = "Transaction Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var amountTextField: UITextField = {
        let amountField = UITextField()
        amountField.placeholder = "Transaction Amount"
        amountField.leftViewMode = .always
        amountField.borderStyle = .roundedRect
        amountField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        amountField.translatesAutoresizingMaskIntoConstraints = false
        return amountField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton : UIButton = {
        let button = UIButton(configuration: .bordered())
        button.setTitle("Save Transaction", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var errorMessageLabel : UILabel = {
        let errorMessage = UILabel()
        errorMessage.text = ""
        errorMessage.textColor = UIColor.red
        errorMessage.numberOfLines = 0
        return errorMessage
    }()
    
    lazy var amountLabel: UILabel = {
       let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var transactionsTotalLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var transactionTotal: Double {
        let transactions = fetchedResultsController.fetchedObjects ?? []
        return transactions.reduce(0) {
            next, transactions in next+transactions.amount
        }
    }
    private func resetForms() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    private func updateTransactionTotal() {
        transactionsTotalLabel.text = transactionTotal.formatAsCurrency()
    }
    
    init(persistentContainer: NSPersistentContainer, budgetCategory: BudgetCategory) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        super.init(nibName: nil, bundle: nil)
        
        // create request based on selected budget category
        let request = Transactions.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            resetForms()
        }
        catch {
            errorMessageLabel.text = "Unable to fetch transactions"
            
        }
    }
    override  func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTransactionTotal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        // stackview
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(transactionsTotalLabel)
        stackView.addArrangedSubview(tableView)

        view.addSubview(stackView)
        
        //Add Constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
    private var isFormValid: Bool {
        guard let name = nameTextField.text,
              let amount = amountTextField.text  else {
            return false
        }
        return !amount.isEmpty && !name.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func deleteTransaction(_ transaction: Transactions) {
        persistentContainer.viewContext.delete(transaction)
        do {
            try persistentContainer.viewContext.save()
            
        }
        catch {
            errorMessageLabel.text = "Unable to delete transaction"
        }
        
    }
    
    
    private func saveTransaction() {
        guard let name = nameTextField.text,
              let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transactions(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.dateCreated = Date()
        transaction.category = budgetCategory
      //  budgetCategory.addToTransactions(transaction)
        
        do {
            try persistentContainer.viewContext.save()
            tableView.reloadData()
        }
        catch {
            errorMessageLabel.text = "Unable To Save Transaction"
        }
    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid"
        }
    }
    
}

extension BudgetDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        let transact = fetchedResultsController.object(at: indexPath)
        //cell config
        var content = cell.defaultContentConfiguration()
        content.text = transact.name
        content.secondaryText = transact.amount.formatAsCurrency()
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (fetchedResultsController.fetchedObjects ?? []).count
    }
}

extension BudgetDetailViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTransactionTotal()
        tableView.reloadData()
    }
  }

extension BudgetDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = fetchedResultsController.object(at: indexPath)
            deleteTransaction(transaction)
        }
        else {
            
        }
    }
}
