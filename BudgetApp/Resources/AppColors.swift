import UIKit

enum AppColor {
    case background
    case button
    case element
    case elementText
    case elementBorder
    case tableViewHeader

    var uiColor: UIColor {
        switch self {
        case .background:
            return UIColor.systemBackground
        case .button:
            return UIColor.systemBlue
        case .element:
            return UIColor.white.withAlphaComponent(0.7)
        case .elementText:
            return UIColor.black.withAlphaComponent(0.8)
        case .elementBorder:
            return UIColor.white.withAlphaComponent(0.9)
        case .tableViewHeader:
            return UIColor.white.withAlphaComponent(0.4)
        }
    }
}

enum ChartColors {
    static let palette: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .brown,
        .magenta,
        UIColor(red: 0.0, green: 0.7, blue: 0.7, alpha: 1),
        UIColor(red: 0.9, green: 0.7, blue: 0.1, alpha: 1),
        UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1),
        UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1),
        UIColor(red: 0.1, green: 0.6, blue: 0.9, alpha: 1),
        UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1),
        UIColor(red: 0.4, green: 0.9, blue: 0.4, alpha: 1),
        UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1)   
    ]
    
    static func color(for index: Int) -> UIColor {
        return palette[index % palette.count]
    }
}

enum AppGradientColor {
    case background

    var colors: [UIColor] {
        switch self {
        case .background:
            return [UIColor.systemPurple.withAlphaComponent(0.5), UIColor.systemBlue.withAlphaComponent(0.5)]
        }
    }
    
    var gradientLayer: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
}
