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
    
    init(persistentContainer: NSPersistentContainer, budgetCategory: BudgetCategory) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        super.init(nibName: nil, bundle: nil)
    }
    override  func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        //Add Constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
    
}

extension BudgetDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

extension BudgetDetailViewController : UITableViewDelegate {
    
}
