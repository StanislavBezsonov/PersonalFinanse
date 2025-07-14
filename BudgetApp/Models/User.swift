import Foundation
import UIKit

enum Gender: String, Codable {
    case male
    case female
}

struct User: Codable {
    let id: String
    var name: String
    var gender: Gender
    var photoPath: String
    var email: String
    let categories: [Category]  
}

extension User {
    var avatarImage: UIImage? {
        ImageStorageManager.shared.loadImage(from: photoPath)
    }
}
