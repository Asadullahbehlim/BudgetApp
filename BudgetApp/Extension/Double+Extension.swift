//
//  Double+Extension.swift
//  BudgetApp
//
//  Created by Asadullah Behlim on 10/04/23.
//

import Foundation
extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
