import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        if UserManager.shared.currentUser != nil {
            showMainInterface()
        } else {
            showLogin()
        }

        window?.makeKeyAndVisible()
    }

    func showLogin() {
        let loginVC = LoginViewController()
        loginVC.onLoginSuccess = { [weak self] in
            self?.showMainInterface()
        }
        let loginNav = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = loginNav
    }

    func showMainInterface() {
        let tabBarController = MainTabBarController()
        window?.rootViewController = tabBarController
    }
}
