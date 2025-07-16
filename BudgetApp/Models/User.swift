import Foundation
import UIKit

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
    var photoPath: String
    var email: String
    let categories: [Category]
    let source: UserSource
}

extension User {
    var avatarImage: UIImage? {
        if photoPath.starts(with: "http") {
            if let url = URL(string: photoPath),
               let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
        } else {
            return ImageStorageManager.shared.loadImage(from: photoPath)
        }
        return nil
    }
}
