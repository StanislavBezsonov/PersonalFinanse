import UIKit
import DGCharts

class DashboardViewController: UIViewController, MonthlyTopCategoriesTableViewDelegate {
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly Expenses"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chartView = RoundGraphView()
    private let monthlyTableView = MonthlyTopCategoriesTableView()
    private let gradientLayer = AppGradientColor.background.gradientLayer

    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyTableView.monthDelegate = self
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let categorySums = TransactionManager.shared.totalExpensesByCategoryForCurrentMonth()
        chartView.updateData(categorySums: categorySums)

        let lastTwelveMonthsData = TransactionManager.shared.lastTwelveMonthsTopCategories()
        monthlyTableView.updateData(lastTwelveMonthsData)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupLayout() {
        view.backgroundColor = AppColor.background.uiColor
        if gradientLayer.superlayer == nil {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }

        view.addSubview(titleLabel)
        view.addSubview(chartView)
        view.addSubview(monthlyTableView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        monthlyTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            chartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            monthlyTableView.topAnchor.constraint(equalTo: chartView.bottomAnchor),
            monthlyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthlyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            monthlyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func didSelectMonth(_ monthData: MonthlyData) {
        let categorySums = TransactionManager.shared.totalExpensesByCategory(forMonth: monthData.monthDate)
        chartView.updateData(categorySums: categorySums)
        titleLabel.text = "\(monthData.monthName) Expenses"
    }
}
