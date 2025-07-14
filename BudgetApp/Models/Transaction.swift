import Foundation

enum TransactionType: String, Codable {
    case income
    case expense
}

struct Transaction: Codable {
    let id: String
    let userID: String
    var amount: Double
    var date: Date
    var category: Category
    var details: String?
    var type: TransactionType
}
