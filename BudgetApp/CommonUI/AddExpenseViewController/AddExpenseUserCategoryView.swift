import UIKit

final class AddExpenseUserCategoryView: UIView {

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        iv.layer.borderWidth = 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "square.and.arrow.up")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        iv.layer.borderWidth = 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(avatarImageView)
        addSubview(categoryImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            categoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryImageView.widthAnchor.constraint(equalToConstant: 100),
            categoryImageView.heightAnchor.constraint(equalTo: categoryImageView.widthAnchor)
        ])
        
        let heightConstraint = heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = UILayoutPriority(750)
        heightConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        categoryImageView.layer.cornerRadius = categoryImageView.bounds.width / 2
    }
    
    func setAvatar(photoPath: String?, gender: Gender) {
        guard let photoPath = photoPath, !photoPath.isEmpty else {
            avatarImageView.image = DefaultAvatar.image(for: gender)
            return
        }

        if let image = ImageStorageManager.shared.loadImage(from: photoPath) {
            avatarImageView.image = image
        } else {
            avatarImageView.image = DefaultAvatar.image(for: gender)
        }
    }
    
    func setCategoryImage(photoPath: String?) {
        guard let photoPath = photoPath, !photoPath.isEmpty else {
            categoryImageView.image = nil
            return
        }
        categoryImageView.image = UIImage(named: photoPath)
    }
}
