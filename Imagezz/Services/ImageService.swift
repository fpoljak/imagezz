//
//  ImageService.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ImageService {
    
    private static let cacheDuration = 30 * 24 * 60 * 60
    private static let diskCapacity = 256 * 1024 * 1024
    private static let memoryCapacity: UInt64 = 64 * 1024 * 1024
    private static let memoryCapacityAfterPurge: UInt64 = 8 * 1024 * 1024
    private static let maximumActiveDownloads = 8
    
    private static let imageCache: URLCache = {
        return URLCache(memoryCapacity: Int(memoryCapacity), diskCapacity: diskCapacity, diskPath: "imagezz_image_disk_cache")
    }()
    
    private static var downloader: ImageDownloader = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = imageCache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        let imageCache = AutoPurgingImageCache(memoryCapacity: memoryCapacity, preferredMemoryUsageAfterPurge: memoryCapacityAfterPurge)
        let downloader = ImageDownloader(configuration: configuration, downloadPrioritization: .fifo, maximumActiveDownloads: maximumActiveDownloads, imageCache: imageCache)
        
        UIImageView.af.sharedImageDownloader = downloader
        
        return downloader
    }()
    
    private static var memoryCache: ImageRequestCache {
        return downloader.imageCache!
    }
    
    static private let appDelegate: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    private static func requestForUrl(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("max-age=\(cacheDuration)", forHTTPHeaderField: "Cache-Control")
        var headers = request.allHTTPHeaderFields
        headers?.removeValue(forKey: "Expires")
        headers?.removeValue(forKey: "s-maxage")
        
        return request
    }
    
    static func cachedImageForUrl(_ url: URL) -> UIImage? {
        if let cachedImage = memoryCache.image(withIdentifier: url.absoluteString) {
            return cachedImage
        }
        
        let request = requestForUrl(url)
        
        if let cachedImageResponse = imageCache.cachedResponse(for: request) {
            if let image = UIImage(data: cachedImageResponse.data) {
                return image
            }
        }
        
        return nil
    }
    
    static func cachedImageForUrlString(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return cachedImageForUrl(url)
    }
    
    static func loadImage(url: URL, completion: @escaping ((UIImage?) -> Void), placeholderImage: UIImage? = nil) {
        if let cachedImage = cachedImageForUrl(url) {
            completion(cachedImage)
            return
        }
        
        let request = requestForUrl(url)
        
        downloader.download(request) { response in
            guard let image = try? response.result.get() else {
                completion(placeholderImage)
                return
            }
            
            memoryCache.add(image, withIdentifier: url.absoluteString)
            completion(image)
        }
    }
    
    static func loadImage(urlString: String, completion: @escaping ((UIImage?) -> Void), placeholderImage: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            completion(placeholderImage)
            return
        }
        
        loadImage(url: url, completion: completion, placeholderImage: placeholderImage)
    }
}

