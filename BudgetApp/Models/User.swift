import Foundation
import UIKit

enum DefaultAvatar {
    case male
    case female

    var image: UIImage? {
        switch self {
        case .male:
            return UIImage(named: "man_icon")
        case .female:
            return UIImage(named: "woman_icon")
        }
    }
    
    static func image(for gender: Gender) -> UIImage? {
        switch gender {
        case .male: return DefaultAvatar.male.image
        case .female: return DefaultAvatar.female.image
        }
    }
}

enum Gender: String, Codable {
    case male
    case female
}

enum UserSource: String, Codable {
    case local
    case remote
}

struct User: Codable {
    let id: String
    var name: String
    var gender: Gender
    var photoPath: String?
    var email: String
    let categories: [Category]
    let source: UserSource
}

extension User {
    var avatarImage: UIImage? {
        if let path = photoPath, path.starts(with: "http"),
           let url = URL(string: path),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            return image
        }

        if let path = photoPath, !path.isEmpty,
           let image = ImageStorageManager.shared.loadImage(from: path) {
            return image
        }

        return DefaultAvatar.image(for: gender)
    }
}

