import UIKit

protocol AddExpenseDateViewDelegate: AnyObject {
    func dateDidChange(_ date: Date)
}

final class AddExpenseDateView: UIView {
    
    weak var delegate: AddExpenseDateViewDelegate?
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date:"
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = AppColor.elementText.uiColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let yesterdayButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Yesterday", for: .normal)
        btn.setTitleColor(AppColor.elementText.uiColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let todayButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Today", for: .normal)
        btn.setTitleColor(AppColor.elementText.uiColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let calendarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "calendar"), for: .normal)
        btn.tintColor = AppColor.elementText.uiColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [calendarButton, yesterdayButton, todayButton])
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var datePicker: UIDatePicker?
    private var datePickerContainer: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = AppColor.element.uiColor
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        
        addSubview(dateLabel)
        addSubview(buttonsStackView)
        
        yesterdayButton.addTarget(self, action: #selector(selectYesterday), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(selectToday), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(toggleDatePicker), for: .touchUpInside)
        selectToday()
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: buttonsStackView.centerYAnchor),
            
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            buttonsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: 16),
            
            heightAnchor.constraint(equalToConstant: 44)

        ])
    }
    
    @objc private func selectYesterday() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        updateDate(yesterday)
    }
    
    @objc private func selectToday() {
        let today = Date()
        updateDate(today)
    }
    
    @objc private func toggleDatePicker() {
        guard let parentVC = self.parentViewController else { return }

        let popup = DatePickerPopupViewController()
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve

        popup.onDatePicked = { [weak self] date in
            self?.updateDate(date)
        }

        parentVC.present(popup, animated: true)
    }
            
    private func updateDate(_ date: Date) {
        delegate?.dateDidChange(date)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: date))"
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController {
                return vc
            }
            responder = next
        }
        return nil
    }
}
