import UIKit

final class GenderSelectorView: UIView {
    
    private let segmentedControl: PrimarySegmentedControl = {
        let control = PrimarySegmentedControl(items: ["Male", "Female"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    var selectedGender: Gender {
        return segmentedControl.selectedSegmentIndex == 0 ? .male : .female
    }
    
    var onGenderChanged: ((Gender) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        segmentedControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)
    }

    @objc private func genderChanged() {
        onGenderChanged?(selectedGender)
    }
}
