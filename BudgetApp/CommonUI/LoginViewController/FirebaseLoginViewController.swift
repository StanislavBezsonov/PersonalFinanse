import UIKit
import FirebaseAuth

final class FirebaseLoginViewController: UIViewController {

    var onLoginSuccess: (() -> Void)?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login to Cloud Account"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let emailTextField: PrimaryTextField = {
        let tf = PrimaryTextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.textContentType = .emailAddress
        return tf
    }()

    private let passwordTextField: PrimaryTextField = {
        let tf = PrimaryTextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.textContentType = .password
        return tf
    }()

    private let loginButton: PrimaryButton = {
        let btn = PrimaryButton(type: .custom)
        btn.setTitle("Login", for: .normal)
        return btn
    }()
    
    private let signUpButton: PrimaryButton = {
        let btn = PrimaryButton(type: .custom)
        btn.setTitle("Sign up", for: .normal)
        return btn
    }()

    private let useLocalVersion: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Use offline version", for: .normal)
        btn.setTitleColor(AppColor.elementText.uiColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()

    private let gradientLayer = AppGradientColor.background.gradientLayer

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background.uiColor
        setupLayout()
        setupActions()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func setupLayout() {
        if gradientLayer.superlayer == nil {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [titleLabel, emailTextField, passwordTextField, loginButton, signUpButton, useLocalVersion].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),

            useLocalVersion.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            useLocalVersion.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            useLocalVersion.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        useLocalVersion.addTarget(self, action: #selector(handleUseLocalVersion), for: .touchUpInside)
    }

    @objc private func handleLogin() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""

        guard isValidEmail(email) else {
            showAlert("Please enter a valid email.")
            return
        }

        guard !password.isEmpty else {
            showAlert("Please enter your password.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert("Login failed: \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {
                self?.showAlert("User ID not found after login.")
                return
            }
            
            FirebaseUserManager.shared.fetchUser(withID: uid) { result in
                switch result {
                case .success(let user):
                    UserManager.shared.currentUser = user
                    
                    TransactionManager.shared.loadRemoteTransactions(for: user.id) {
                        DispatchQueue.main.async {
                            self?.onLoginSuccess?()
                        }
                    }

                case .failure(let error):
                    break
                }
            }
        }
    }


    @objc private func handleSignUp() {
        let signUpVC = FirebaseSignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func handleUseLocalVersion() {
        let localLoginVC = LocalLoginViewController()
        navigationController?.pushViewController(localLoginVC, animated: true)        
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColor.elementText.uiColor
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}
