import Foundation
import UIKit

struct Category: Codable, Equatable {
    let id: String
    let name: String
    let iconName: String
}

extension Category {
    var icon: UIImage? {
        guard let image = ImageStorageManager.shared.loadImage(from: iconName) else {
            print("Icon not found for category: \(name)")
            return nil
        }
        return image
    }
}
