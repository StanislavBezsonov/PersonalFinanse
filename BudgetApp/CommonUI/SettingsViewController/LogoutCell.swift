import UIKit

class LogoutCell: BaseTableViewCell {
    
    private lazy var logoutLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        logoutLabel.textAlignment = .right
        logoutLabel.textColor = .red
        logoutLabel.text = "Logout"
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoutLabel)
        
        NSLayoutConstraint.activate([
            logoutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logoutLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            logoutLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
