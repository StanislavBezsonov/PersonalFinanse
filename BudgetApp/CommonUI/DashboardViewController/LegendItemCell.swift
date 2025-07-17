import UIKit

class LegendItemCell: UICollectionViewCell {
    static let reuseIdentifier = "LegendItemCell"

    private let colorView = UIView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        colorView.layer.cornerRadius = 5
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)

        label.font = .systemFont(ofSize: 13)
        label.textColor = AppColor.elementText.uiColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 10),
            colorView.heightAnchor.constraint(equalToConstant: 10),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(color: UIColor, text: String) {
        colorView.backgroundColor = color
        label.text = text
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let maxWidth: CGFloat
        if let collectionView = self.superview as? UICollectionView {
            maxWidth = collectionView.bounds.width / 3 - 16
        } else {
            maxWidth = layoutAttributes.frame.width > 0 ? layoutAttributes.frame.width : 100
        }

        let targetSize = CGSize(width: maxWidth, height: UIView.layoutFittingCompressedSize.height)
        
        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        var newFrame = layoutAttributes.frame
        newFrame.size = CGSize(width: ceil(size.width), height: ceil(size.height))
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

