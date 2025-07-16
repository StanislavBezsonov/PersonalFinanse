import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class FirebaseSignUpViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
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

    private let genderSelector = GenderSelectorView()

    private let signUpButton: PrimaryButton = {
        let btn = PrimaryButton(type: .custom)
        btn.setTitle("Sign Up", for: .normal)
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

        [titleLabel, emailTextField, passwordTextField, genderSelector, signUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        setupConstraints()
    }

    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }

    @objc private func handleSignUp() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""

        guard isValidEmail(email) else {
            showAlert("Please enter a valid email.")
            return
        }
        guard password.count >= 6 else {
            showAlert("Password must be at least 6 characters.")
            return
        }

        FirebaseUserManager.shared.signUp(email: email, password: password, gender: genderSelector.selectedGender) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserManager.shared.currentUser = user
                    self?.navigationController?.popToRootViewController(animated: true)
                case .failure(let error):
                    self?.showAlert("Signup failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func uploadAvatarImage(_ image: UIImage, forUID uid: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        let storageRef = Storage.storage().reference().child("avatars/\(uid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Storage upload error:", error.localizedDescription)
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString)
                } else {
                    completion(nil)
                }
            }
        }
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
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}

private extension FirebaseSignUpViewController {
    func setupConstraints() {
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

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            genderSelector.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            genderSelector.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            genderSelector.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            genderSelector.heightAnchor.constraint(equalToConstant: 44),

            signUpButton.topAnchor.constraint(equalTo: genderSelector.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}
