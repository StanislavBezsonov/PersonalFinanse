import UIKit

class MainTabBarController: UITabBarController {
    
    private let gradientLayer = AppGradientColor.background.gradientLayer

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
        if gradientLayer.superlayer == nil {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupViewControllers() {
        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        let dashboardNavVC = UINavigationController(rootViewController: dashboardVC)
        dashboardNavVC.navigationBar.tintColor = AppColor.elementText.uiColor

        let expensesCategoryVC = ExpenseCategoryViewController()
        expensesCategoryVC.tabBarItem = UITabBarItem(title: "New expense", image: UIImage(systemName: "cart"), tag: 1)
        let expensesNavVC = UINavigationController(rootViewController: expensesCategoryVC)
        expensesNavVC.navigationBar.tintColor = AppColor.elementText.uiColor
        
        let historyListVC = HistoryListViewController()
        historyListVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "list.bullet"), tag: 2)
        let historyListNavVC = UINavigationController(rootViewController: historyListVC)
        historyListNavVC.navigationBar.tintColor = AppColor.elementText.uiColor

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        settingsNavVC.navigationBar.tintColor = AppColor.elementText.uiColor
        
        viewControllers = [dashboardNavVC, expensesNavVC, historyListNavVC, settingsNavVC]
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = UIColor.black.withAlphaComponent(0.9)
        tabBar.unselectedItemTintColor = UIColor.darkGray.withAlphaComponent(0.8)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       if let navController = viewController as? UINavigationController {
           navController.popToRootViewController(animated: false)
       }
    }
}
