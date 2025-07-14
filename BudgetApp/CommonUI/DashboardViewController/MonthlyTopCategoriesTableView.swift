import UIKit

struct MonthlyCategory {
    let category: String
    let amount: Double
}

struct MonthlyData {
    let monthDate: Date
    let monthName: String
    let totalAmount: Double
    let topCategories: [MonthlyCategory]
}

protocol MonthlyTopCategoriesTableViewDelegate: AnyObject {
    func didSelectMonth(_ monthData: MonthlyData)
}

class MonthlyTopCategoriesTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var monthlyData: [MonthlyData] = []
    weak var monthDelegate: MonthlyTopCategoriesTableViewDelegate?
    
    init() {
        super.init(frame: .zero, style: .plain)
        sectionHeaderTopPadding = 0
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(MonthlyTopCategoriesCell.self, forCellReuseIdentifier: MonthlyTopCategoriesCell.reuseID)
        register(MonthlyTopCategoriesSection.self, forHeaderFooterViewReuseIdentifier: MonthlyTopCategoriesSection.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ data: [MonthlyData]) {
        self.monthlyData = data
        reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthlyData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthlyData[section].topCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyTopCategoriesCell.reuseID, for: indexPath) as? MonthlyTopCategoriesCell else {
            return UITableViewCell()
        }
        let category = monthlyData[indexPath.section].topCategories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    // MARK: Header View
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MonthlyTopCategoriesSection.reuseIdentifier) as? MonthlyTopCategoriesSection else {
            return nil
        }
        let month = monthlyData[section]
        header.configure(monthName: month.monthName, totalAmount: month.totalAmount)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        header.addGestureRecognizer(tapGesture)
        header.tag = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let month = monthlyData[indexPath.section]
        monthDelegate?.didSelectMonth(month)
        tableView.deselectRow(at: indexPath, animated: true)
    }
                
    @objc private func headerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let headerView = gestureRecognizer.view else { return }
        let section = headerView.tag
        let month = monthlyData[section]
        monthDelegate?.didSelectMonth(month)      
    }
}
