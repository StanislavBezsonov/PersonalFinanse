import UIKit

protocol AddExpenseKeyboardDelegate: AnyObject {
    func didTapKey(_ key: String)
    func didTapClear()
}

class AddExpenseKeyboard: UIView {

    weak var delegate: AddExpenseKeyboardDelegate?

    private let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "C"]
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboard()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupKeyboard() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for row in keys {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8

            for key in row {
                let button = UIButton(type: .system)
                button.setTitle(key, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
                button.setTitleColor(AppColor.elementText.uiColor, for: .normal)
                button.backgroundColor = AppColor.element.uiColor
                button.layer.cornerRadius = 8
                button.layer.borderWidth = 2
                button.layer.borderColor = AppColor.elementBorder.uiColor.cgColor
                button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }

            stackView.addArrangedSubview(rowStack)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    @objc private func keyTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if title == "C" {
            delegate?.didTapClear()
        } else {
            delegate?.didTapKey(title)
        }
    }
}
