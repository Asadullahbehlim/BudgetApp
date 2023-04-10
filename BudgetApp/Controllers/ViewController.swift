//
//  ViewController.swift
//  BudgetApp
//
//  Created by Asadullah Behlim on 05/04/23.
//

import UIKit
import CoreData

class ViewController:  UITableViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
    }
    
    private func setupUI() {
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddCategoryButton))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    @objc func showAddCategoryButton(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        self.navigationController?.pushViewController(BudgetDetailViewController(persistentContainer: persistentContainer, budgetCategory: budgetCategory), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        
       var configuration = cell.defaultContentConfiguration()
        configuration.text = budgetCategory.name
        cell.contentConfiguration = configuration
        return cell
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
