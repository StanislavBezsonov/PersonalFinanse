import UIKit

class BaseTableViewCell: UITableViewCell {
    static var reuseID: String {
        return String(describing: self)
    }
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupStyle() {
        selectionStyle = .none
        backgroundColor = AppColor.element.uiColor
        layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        layer.borderWidth = 0.5
    }    
}
