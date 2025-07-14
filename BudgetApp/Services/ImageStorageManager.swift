import UIKit

final class ImageStorageManager {
    static let shared = ImageStorageManager()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    private init() {}
    
    func loadImage(from imageName: String?) -> UIImage? {
        guard let imageName = imageName, !imageName.isEmpty else { return nil }
        
        if let cached = memoryCache.object(forKey: imageName as NSString) {
            return cached
        }
        
        if let assetImage = UIImage(named: imageName) {
            memoryCache.setObject(assetImage, forKey: imageName as NSString)
            return assetImage
        }
        
        let url = imageURL(for: imageName)
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: imageName as NSString)
            return image
        }
        
        return nil
    }
    
    func saveImage(_ image: UIImage, name: String? = nil) -> String? {
        let imageName = (name ?? UUID().uuidString) + ".jpg"
        let url = imageURL(for: imageName)

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }

        do {
            try data.write(to: url)
            memoryCache.setObject(image, forKey: imageName as NSString)
            return imageName
        } catch {
            return nil
        }
    }

    private func imageURL(for name: String) -> URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(name)
    }
}
