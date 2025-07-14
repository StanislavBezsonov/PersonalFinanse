import UIKit

final class PrimaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        setTitleColor(AppColor.elementText.uiColor, for: .normal)
        backgroundColor = AppColor.element.uiColor
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.borderWidth = 2
        layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = AppColor.elementText.uiColor.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 10
    }
}
