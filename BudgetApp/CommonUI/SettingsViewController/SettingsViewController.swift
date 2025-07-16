import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var tableView = UITableView()
    private let gradientLayer = AppGradientColor.background.gradientLayer

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LogoutCell.self, forCellReuseIdentifier: LogoutCell.reuseID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func setupLayout() {
        title = "Settings"

        view.backgroundColor = AppColor.background.uiColor
        if gradientLayer.superlayer == nil {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func handleLogout() {
        UserManager.shared.logout()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            NotificationCenter.default.post(name: .userDidLogout, object: nil)
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogoutCell.reuseID, for: indexPath) as? LogoutCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            handleLogout()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
