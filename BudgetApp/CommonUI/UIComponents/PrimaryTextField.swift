import UIKit

final class PrimaryTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        self.borderStyle = .none
        self.backgroundColor = AppColor.element.uiColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        self.textColor = AppColor.elementText.uiColor
        self.tintColor = AppColor.elementText.uiColor

        setLeftPaddingPoints(12)
    }

    private func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 44))
        leftView = paddingView
        leftViewMode = .always
    }
}
