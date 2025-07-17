import UIKit

final class LoadingSpinnerView {
    static let shared = LoadingSpinnerView()

    private var spinner: UIActivityIndicatorView?
    private var backgroundView: UIView?

    private init() {}

    func show(on view: UIView? = nil) {
        guard spinner == nil else { return }

        let targetView = view ?? Self.getKeyWindow()

        let background = UIView(frame: targetView?.bounds ?? .zero)
        background.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.center = background.center
        indicator.startAnimating()

        background.addSubview(indicator)
        targetView?.addSubview(background)

        spinner = indicator
        backgroundView = background
    }

    func hide() {
        spinner?.stopAnimating()
        backgroundView?.removeFromSuperview()
        spinner = nil
        backgroundView = nil
    }

    private static func getKeyWindow() -> UIView? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}
