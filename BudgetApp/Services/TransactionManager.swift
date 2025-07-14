import Foundation


class TransactionManager {
    static let shared = TransactionManager()
    private let defaults = UserDefaults.standard
    private let transactionsKey = "transactionsKey"
    
    private var transactions: [Transaction] = []
       
    private init() {
        loadTransactions()
    }
    
    var allTransactions: [Transaction] {
        return transactions
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }
    
    func removeTransaction(withId id: String) {
        transactions.removeAll { $0.id == id }
        saveTransactions()
    }
    
    func removeAllTransactions() {
        transactions.removeAll()
        saveTransactions()
    }
    
    func updateTransaction(_ updatedTransaction: Transaction) {
        if let index = transactions.firstIndex(where: {$0.id == updatedTransaction.id}) {
            transactions[index] = updatedTransaction
            saveTransactions()
        }
    }
    
    func totalExpensesByCategory() -> [String: Double] {
        let expenses = transactions.filter { $0.type == .expense }
        var categorySum: [String: Double] = [:]
        for expence in expenses {
            categorySum[expence.category.name, default: 0] += expence.amount
        }
        return categorySum
    }
    
    func totalExpensesByCategoryForCurrentMonth() -> [String: Double] {
        let calendar = Calendar.current
        let now = Date()

        let expenses = transactions.filter { transaction in
            transaction.type == .expense &&
            calendar.isDate(transaction.date, equalTo: now, toGranularity: .month)
        }

        var categorySum: [String: Double] = [:]
        for expense in expenses {
            categorySum[expense.category.name, default: 0] += expense.amount
        }

        return categorySum
    }
    
    func totalExpensesByCategory(forMonth date: Date) -> [String: Double] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)

        let filtered = transactions.filter {
            $0.type == .expense &&
            calendar.component(.month, from: $0.date) == components.month &&
            calendar.component(.year, from: $0.date) == components.year
        }

        var categorySum: [String: Double] = [:]
        for t in filtered {
            categorySum[t.category.name, default: 0] += t.amount
        }
        return categorySum
    }
    
    func lastTwelveMonthsTopCategories() -> [MonthlyData] {
        let calendar = Calendar.current
        let now = Date()
        
        var months: [Date] = []
        for i in 0..<12 {
            if let monthDate = calendar.date(byAdding: .month, value: -i, to: now),
               let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) {
                months.append(firstDay)
            }
        }
        
        var results: [MonthlyData] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        
        for monthStart in months {
            guard let monthRange = calendar.range(of: .day, in: .month, for: monthStart),
                  let monthEnd = calendar.date(byAdding: .day, value: monthRange.count - 1, to: monthStart) else {
                continue
            }
            
            let filteredExpenses = transactions.filter {
                $0.type == .expense && $0.date >= monthStart && $0.date <= monthEnd
            }
            
            var categorySums: [String: Double] = [:]
            for exp in filteredExpenses {
                categorySums[exp.category.name, default: 0] += exp.amount
            }
            
            let total = categorySums.values.reduce(0, +)
            
            let sortedCategories = categorySums.sorted { $0.value > $1.value }
            let topCategories = sortedCategories.prefix(3).map { MonthlyCategory(category: $0.key, amount: $0.value) }
            
            let monthName = dateFormatter.string(from: monthStart)
            
            let monthlyData = MonthlyData(monthDate: monthStart, monthName: monthName, totalAmount: total, topCategories: topCategories)
            results.append(monthlyData)
        }
        
        return results
    }    
    
    func totalExpenses(forMonth monthDate: Date) -> Double {
        let calendar = Calendar.current
        let monthExpenses = transactions.filter {
            $0.type == .expense &&
            calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month)
        }
        return monthExpenses.reduce(0) { $0 + $1.amount }
    }
        
    private func saveTransactions() {
        do {
            let savedData = try JSONEncoder().encode(transactions)
            defaults.set(savedData, forKey: transactionsKey)
        } catch {
            print("Error encoding transactions: \(error)")
        }
    }
    
    private func loadTransactions() {
        guard let savedData = defaults.data(forKey: transactionsKey) else { return }
        do {
            transactions = try JSONDecoder().decode([Transaction].self, from: savedData)
        } catch {
            print("Error decoding saved transactions: \(error)")
        }
    }
}
