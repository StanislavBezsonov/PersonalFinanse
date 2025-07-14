import UIKit

final class DatePickerPopupViewController: UIViewController {

    var onDatePicked: ((Date) -> Void)?

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.elementText.uiColor.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.background.uiColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.maximumDate = Date()
        picker.tintColor = AppColor.elementText.uiColor
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapOutside()
    }

    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(datePicker)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320),
            containerView.heightAnchor.constraint(equalToConstant: 340),

            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    private func setupTapOutside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tapGesture)
    }

    @objc private func backgroundTapped() {
        dismiss(animated: true)
    }

    @objc private func dateChanged() {
        onDatePicked?(datePicker.date)
        dismiss(animated: true)
    }
}
