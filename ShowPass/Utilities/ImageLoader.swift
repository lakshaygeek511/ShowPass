import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100 // Maximum number of images to cache
        cache.totalCostLimit = 100 * 1024 * 1024 // 100 MB
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        // Check if image exists in cache
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // If not in cache, download the image
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Store in cache
            self?.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        
        task.resume()
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
} 