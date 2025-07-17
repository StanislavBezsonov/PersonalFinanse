import UIKit

final class LocalLoginViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let nameTextField: PrimaryTextField = {
        let tf = PrimaryTextField()
        tf.placeholder = "Your name"
        return tf
    }()

    private let genderSelector = GenderSelectorView()

    private let avatarImageView = AvatarImageView()

    private let loginButton: PrimaryButton = {
        let btn = PrimaryButton(type: .custom)
        btn.setTitle("Login", for: .normal)
        return btn
    }()
    
    private let gradientLayer = AppGradientColor.background.gradientLayer

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background.uiColor
        avatarImageView.delegate = self

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

        [titleLabel, nameTextField, genderSelector, avatarImageView, loginButton].forEach {
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

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            genderSelector.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            genderSelector.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            genderSelector.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            genderSelector.heightAnchor.constraint(equalToConstant: 44),

            avatarImageView.topAnchor.constraint(equalTo: genderSelector.bottomAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            loginButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func setupActions() {
        genderSelector.onGenderChanged = { [weak self] gender in
            self?.avatarImageView.updateImage(isMale: gender == .male)
        }

        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

    @objc private func handleLogin() {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmedName.isEmpty else {
            showAlert("Please enter your name.")
            return
        }

        guard let image = avatarImageView.image,
              let filename = ImageStorageManager.shared.saveImage(image) else {
            showAlert("Failed to save avatar image")
            return
        }

        let user = User(
            id: UUID().uuidString,
            name: trimmedName,
            gender: genderSelector.selectedGender,
            photoPath: filename,
            email: "",
            categories: DefaultCategories.all,
            source: .local
        )

        UserManager.shared.currentUser = user
        
        changeNavController()
    }

    private func changeNavController() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            let tabBarController = MainTabBarController()
            sceneDelegate.window?.rootViewController = tabBarController
            sceneDelegate.window?.makeKeyAndVisible()
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
}

extension LocalLoginViewController: AvatarImageViewDelegate {
    func didTapAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

extension LocalLoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let image = image {
            avatarImageView.setCustomImage(image)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
