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
            return nil
        }
        return image
    }
}

extension Category {
    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let iconName = dictionary["iconName"] as? String
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.iconName = iconName
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "iconName": iconName
        ]
    }
}
