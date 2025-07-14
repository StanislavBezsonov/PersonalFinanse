import UIKit

class AddExpenseViewController: UIViewController {
    
    // MARK: - Properties
    private var category: Category
    private let userCategoryView = AddExpenseUserCategoryView()
    private let amountInput = AddExpenseAmountTextField(labelText: "Amount of expense")
    private let dateView = AddExpenseDateView()
    private let customKeyboard = AddExpenseKeyboard()
    private var selectedDate: Date = Date()
    
    private let saveButton: PrimaryButton = {
        let btn = PrimaryButton(type: .custom)
        btn.setTitle("Save", for: .normal)
        return btn
    }()

    private let gradientLayer: CAGradientLayer = {
        return AppGradientColor.background.gradientLayer
    }()

    // MARK: - Init
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        self.title = "Add Expense"
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.amountInput.textField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Layout
    private func setupLayout() {
        view.backgroundColor = AppColor.background.uiColor
        view.layer.insertSublayer(gradientLayer, at: 0)

        userCategoryView.setAvatar(photoPath: UserManager.shared.currentUser?.photoPath)
        guard let userCategories = UserManager.shared.currentUser?.categories else {
            return
        }

        let selectedCategory = userCategories.first { $0.name == category.name }
        userCategoryView.setCategoryImage(photoPath: selectedCategory?.iconName)

        let topStackView = UIStackView(arrangedSubviews: [userCategoryView, amountInput, dateView])
        topStackView.axis = .vertical
        topStackView.spacing = 16
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        amountInput.textField.inputView = customKeyboard
        dateView.delegate = self
        customKeyboard.translatesAutoresizingMaskIntoConstraints = false
        customKeyboard.delegate = self
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        view.addSubview(customKeyboard)
        view.addSubview(saveButton)
        view.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topStackView.bottomAnchor.constraint(lessThanOrEqualTo: customKeyboard.topAnchor, constant: -16),
            
            customKeyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customKeyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customKeyboard.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -8),
            customKeyboard.heightAnchor.constraint(equalToConstant: 216),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Actions
    @objc private func datePickerChanged() {
        view.endEditing(true)
    }
    
    @objc private func saveTapped() {
        guard let amountString = amountInput.textField.text?.replacingOccurrences(of: ",", with: "."),
              let amount = Double(amountString),
              amount > 0 else {
            showAlert("Incorrect amount")
            return
        }
        
        guard let userID = UserManager.shared.currentUser?.id else {
            print("No current user")
            return
        }
        
        let newTransaction = Transaction(
            id: UUID().uuidString,
            userID: userID,
            amount: amount,
            date: selectedDate,
            category: category,
            details: "",
            type: .expense
        )
        
        TransactionManager.shared.addTransaction(newTransaction)
        navigateToDashboard()
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColor.elementText.uiColor
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToDashboard() {
        if let tabBarController = self.tabBarController {
            UIView.performWithoutAnimation {
                tabBarController.selectedIndex = 0
            }

            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                navController.popToRootViewController(animated: false)
            }

            if self.presentingViewController != nil {
                self.dismiss(animated: false)
            } else {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}

// MARK: - CustomKeyboardDelegate
extension AddExpenseViewController: AddExpenseKeyboardDelegate, AddExpenseDateViewDelegate {
    func dateDidChange(_ date: Date) {
        selectedDate = date
    }
    
    func didTapKey(_ key: String) {
        if key == "." {
            if amountInput.textField.text?.contains(".") == true { return }
        }
        amountInput.textField.text? += key
    }

    func didTapClear() {
        guard var text = amountInput.textField.text, !text.isEmpty else { return }
        text.removeLast()
        amountInput.textField.text = text
    }
}
