//
//  ImageCache.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private init() {
        // Initialize your cache with appropriate memory and disk capacities
        let cacheSizeMemory = 50 * 1024 * 1024 // 50 MB
        let cacheSizeDisk = 100 * 1024 * 1024 // 100 MB
        
        let cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "imageCache")
        URLCache.shared = cache
    }
    
    func getImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already cached
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            completion(UIImage(data: cachedResponse.data))
            return
        }
        
        // If not cached, download the image and cache it
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Image download error: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}

