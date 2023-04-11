//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Asadullah Behlim on 11/04/23.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    var transactionTotal: Double {
       let transactionsArray : [Transactions] = transactions?.toArray() ?? []
        return transactionsArray.reduce(0) {
            next, transactions in next+transactions.amount
        }
    }
    
    var remainingAmount: String {
        "\(amount - transactionTotal)$"
    }
    
}

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map {$0 as! T }
        return array
    }
}
