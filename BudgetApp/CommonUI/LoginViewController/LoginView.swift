import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapAvatar()
}

class LoginView: UIView, AvatarImageViewDelegate {
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: PrimaryTextField = {
        let tf = PrimaryTextField()
        tf.placeholder = "Your name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let genderSegmentedControl: PrimarySegmentedControl = {
        let control = PrimarySegmentedControl(items: ["Male", "Female"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let avatarImageView = AvatarImageView()
        
    let loginButton: PrimaryButton = {
        let btn = PrimaryButton(type: .custom)
        btn.setTitle("Login", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let gradientLayer: CAGradientLayer = {
        return AppGradientColor.background.gradientLayer
    }()
    private let stackView = UIStackView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        layer.insertSublayer(gradientLayer, at: 0)
        avatarImageView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if gradientLayer.frame != bounds {
            gradientLayer.frame = bounds
        }

        if avatarImageView.bounds.width > 0 {
            avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        }
    }


    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = AppColor.background.uiColor
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(genderSegmentedControl)
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(loginButton)
        
        addSubview(stackView)

        genderSegmentedControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        genderSegmentedControl.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
    }

    func isNameValid() -> Bool {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        return !name.isEmpty
    }
    
    // MARK: - Actions
    
    func didTapAvatar() {
        delegate?.didTapAvatar()
    }
    
    @objc private func genderChanged() {
        let isMale = genderSegmentedControl.selectedSegmentIndex == 0
        avatarImageView.updateImage(isMale: isMale)
    }
}


