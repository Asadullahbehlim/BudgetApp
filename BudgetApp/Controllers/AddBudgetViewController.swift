//
//  AddBudgetViewController.swift
//  BudgetApp
//
//  Created by Asadullah Behlim on 08/04/23.
//

import Foundation
import UIKit
import CoreData

class AddBudgetViewController : UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Budget Name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Budget Amount"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var addBudgetItem: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    lazy var errorMessageLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.red
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text,
              let amount = amountTextField.text  else {
            return false
        }
        return !amount.isEmpty && !name.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private func saveBudgetCategory() {
        guard let name = nameTextField.text,
              let amount = amountTextField.text else {
            return
        }
        do {
            let budgetCategory = BudgetCategory(context: persistentContainer.viewContext)
            budgetCategory.name = name
            budgetCategory.amount = Double(amount)!
            try persistentContainer.viewContext.save()
            dismiss(animated: true)
        }
        
        catch {
            errorMessageLabel.text = "Unable to save budget category"
        }
    }
    
    init(persistentContainer: NSPersistentContainer){
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add Budget"
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(addBudgetItem)
        stackView.addArrangedSubview(errorMessageLabel)
        
        // Add Constraints
        
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBudgetItem.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Add Button Click
        addBudgetItem.addTarget(self, action: #selector(addBudgetTapped), for: .touchUpInside)
    }
    
    @objc func addBudgetTapped(_ sender : UIButton) {
        if isFormValid {
          saveBudgetCategory()
        }
        else {
            errorMessageLabel.text = "Unable to save Budget. Name & Amount is required "
        }
    }
}


extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
