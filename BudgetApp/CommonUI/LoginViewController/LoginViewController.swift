import UIKit

class LoginViewController: UIViewController {
    var onLoginSuccess: (() -> Void)?
    
    private let loginView = LoginView()
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleLogin() {
        guard loginView.isNameValid() else {
            showAlert("Please enter your name.")
            return
        }
        
        let name = loginView.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let genderIndex = loginView.genderSegmentedControl.selectedSegmentIndex
        let gender: Gender = (genderIndex == 0) ? .male : .female

        guard let image = loginView.avatarImageView.image,
              let filename = ImageStorageManager.shared.saveImage(image) else {
            showAlert("Failed to save avatar image")
            return
        }

        let newUser = User(
            id: UUID().uuidString,
            name: name,
            gender: gender,
            photoPath: filename,
            email: "",
            categories: DefaultCategories.all
        )

        UserManager.shared.currentUser = newUser
        onLoginSuccess?()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.view.tintColor = AppColor.elementText.uiColor
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController: LoginViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func didTapAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?

        if let edited = info[.editedImage] as? UIImage {
            selectedImage = edited
        } else if let original = info[.originalImage] as? UIImage {
            selectedImage = original
        }
        
        if let image = selectedImage {
            loginView.avatarImageView.setCustomImage(image)
        }
        
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
