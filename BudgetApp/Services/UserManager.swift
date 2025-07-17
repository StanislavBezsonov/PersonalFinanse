import Foundation
import FirebaseAuth

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
    
    func logout(completion: (() -> Void)? = nil) {
        LoadingSpinnerView.shared.show()

        DispatchQueue.global(qos: .userInitiated).async {
            let userSource = UserManager.shared.currentUser?.source
            print("Logging out user with source: \(String(describing: userSource))")

            if userSource == .remote {
                do {
                    try Auth.auth().signOut()
                    print("Firebase signOut successful")
                } catch {
                    print("Logout error: \(error)")
                }
            }

            DispatchQueue.main.async {
                UserManager.shared.currentUser = nil
                UserDefaults.standard.removeObject(forKey: UserManager.shared.userDefaultsKey)
                UserDefaults.standard.synchronize()
                TransactionManager.shared.removeAllTransactions()

                LoadingSpinnerView.shared.hide()
                completion?()
            }
        }
    }

}
