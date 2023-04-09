//
//  AppDelegate.swift
//  BudgetApp
//
//  Created by Asadullah Behlim on 05/04/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BudgetModel")
        container.loadPersistentStores {
            description, error in
            if let error = error {
                fatalError("Unable to load persistent store: \(error)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        let navController = UINavigationController(rootViewController: ViewController(persistentContainer: persistentContainer))
        window?.rootViewController = navController
        
        return true
    }

}

