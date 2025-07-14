import UIKit

class AddExpenseAmountTextField: UIView {
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = AppColor.elementText.uiColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textAlignment = .right
        tf.isUserInteractionEnabled = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [
                .foregroundColor: AppColor.elementText.uiColor
            ]
        )
        return tf
    }()
    
    init(labelText: String) {
        super.init(frame: .zero)
        label.text = labelText
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.backgroundColor = AppColor.element.uiColor
        self.layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        
        addSubview(label)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44),

            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}
