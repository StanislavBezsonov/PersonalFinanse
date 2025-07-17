import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = AppColor.background.uiColor

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserLogout),
            name: .userDidLogout,
            object: nil
        )
        
        if UserManager.shared.currentUser?.source == .local {
            showMainInterface()
        
        } else if let firebaseUser = Auth.auth().currentUser {
            
            self.showMainInterface()
        
        } else {
            showLogin()
        }

        window?.makeKeyAndVisible()
    }

    private func showLogin() {
        let loginVC = FirebaseLoginViewController()
        loginVC.onLoginSuccess = { [weak self] in
            self?.showMainInterface()
        }
        let nav = UINavigationController(rootViewController: loginVC)
        nav.navigationBar.tintColor = AppColor.elementText.uiColor
        window?.rootViewController = nav
    }

    private func showMainInterface() {
        let tabBarController = MainTabBarController()
        window?.rootViewController = tabBarController
    }
    
    @objc private func handleUserLogout() {
        showLogin()
    }
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
}
