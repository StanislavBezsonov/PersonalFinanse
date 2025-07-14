import UIKit

final class PrimarySegmentedControl: UISegmentedControl {

    override init(items: [Any]?) {
        super.init(items: items)
        setupStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        self.selectedSegmentIndex = 0
        
        self.backgroundColor = AppColor.element.uiColor
        self.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.4)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.elementText.uiColor.withAlphaComponent(0.6),
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.elementText.uiColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        
        self.setTitleTextAttributes(normalAttributes, for: .normal)
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        self.layer.borderWidth = 2
    }
}
