import Foundation

class UserManager {
    static let shared = UserManager()
    private init() {
        loadUserFromDefaults()
    }
    
    private let userDefaultsKey = "currentUser"
    
    var currentUser: User? {
        didSet {
            saveUserToDefaults()
        }
    }
    
    func saveUserToDefaults() {
        guard let currentUser = currentUser else {
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            return
        }
        
        if let encoded = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadUserFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
            let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        } else {
            currentUser = nil
        }
    }
    
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
        TransactionManager.shared.removeAllTransactions()
    }
}
