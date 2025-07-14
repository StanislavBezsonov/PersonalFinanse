import UIKit

class MonthlyTopCategoriesSection: UITableViewHeaderFooterView {
    static let reuseIdentifier = "MonthlyTopCategoriesSection"
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColor.elementText.uiColor
        label.textAlignment = .right
        return label
    }()
    
    private let hStack = UIStackView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = AppColor.tableViewHeader.uiColor
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        
        hStack.addArrangedSubview(monthLabel)
        hStack.addArrangedSubview(totalAmountLabel)
        totalAmountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func configure(monthName: String, totalAmount: Double) {
        monthLabel.text = monthName
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 0
        
        let totalString = formatter.string(from: NSNumber(value: totalAmount)) ?? "\(totalAmount)"
        totalAmountLabel.text = totalString
    }
}
