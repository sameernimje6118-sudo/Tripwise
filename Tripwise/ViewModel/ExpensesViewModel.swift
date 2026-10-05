//
//  ExpensesViewModel.swift
//  Tripwise
//
//  Created by sameer nimje on 29/06/26.
//  Copyright © 2026 Sameer nimje. All rights reserved.
//

import Foundation
import Observation

@Observable
class ExpensesViewModel {

    var expenses: [Expense] = []

    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }

    var totalExpense: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}
