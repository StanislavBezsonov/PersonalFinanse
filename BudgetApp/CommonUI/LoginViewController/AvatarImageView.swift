import UIKit

protocol AvatarImageViewDelegate: AnyObject {
    func didTapAvatar()
}

class AvatarImageView: UIImageView {

    weak var delegate: AvatarImageViewDelegate?
    private var isMale: Bool = true
    private var isCustomImage: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true
        backgroundColor = .tertiarySystemFill
        layer.borderWidth = 2
        layer.borderColor = AppColor.elementBorder.uiColor.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let width = bounds.width
        if width > 0, width.isFinite {
            layer.cornerRadius = width / 2
        }

        if !isCustomImage, image != defaultImage() {
            updateImage(isMale: isMale)
        }
    }
    
    @objc private func avatarTapped() {
        delegate?.didTapAvatar()
    }
    
    func updateImage(isMale: Bool) {
        self.isMale = isMale
        if !isCustomImage {
            let imageName = isMale ? DefaultAvatar.male.image: DefaultAvatar.female.image
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
                self.image = imageName
            }
        }
    }
    
    func setCustomImage(_ image: UIImage) {
        isCustomImage = true
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
            self.image = image
        }
    }
    
    private func defaultImage() -> UIImage? {
        let imageName = isMale ? DefaultAvatar.male.image: DefaultAvatar.female.image
        return imageName
    }
    
    func resetToDefault() {
        isCustomImage = false
        updateImage(isMale: isMale)
    }
}
