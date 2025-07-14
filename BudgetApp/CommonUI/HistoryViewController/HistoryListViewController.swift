import UIKit

class HistoryListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var transactionsByDay: [Date: [Transaction]] = [:]
    private var sortedDates: [Date] = []
    private let gradientLayer = AppGradientColor.background.gradientLayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions history"
        tabBarItem.title = "History"
        setupBackground()
        setupTableView()
    }
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    

    func setupBackground() {
        view.backgroundColor = AppColor.background.uiColor
        if gradientLayer.superlayer == nil {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0

        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryListCell.self, forCellReuseIdentifier: HistoryListCell.reuseID)
        tableView.register(HistorySectionHeaderView.self, forHeaderFooterViewReuseIdentifier: HistorySectionHeaderView.reuseID)
    }
    
    private func loadData() {
        let allTransactions = TransactionManager.shared.allTransactions
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: allTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        
        transactionsByDay = grouped.mapValues { transactions in
            transactions.sorted(by: { $0.date > $1.date })
        }
        
        sortedDates = transactionsByDay.keys.sorted(by: >)
        
        tableView.reloadData()
    }
}

extension HistoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sortedDates[section]
        return transactionsByDay[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = sortedDates[indexPath.section]
        guard let transaction = transactionsByDay[date]?[indexPath.row] else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryListCell.reuseID, for: indexPath) as? HistoryListCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistorySectionHeaderView.reuseID) as? HistorySectionHeaderView else {
            return nil
        }

        let date = sortedDates[section]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        header.configure(with: formatter.string(from: date))
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}
