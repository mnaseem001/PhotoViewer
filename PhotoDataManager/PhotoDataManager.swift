//
//  PhotoDataManager.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/13/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Kingfisher

public class PhotoDataManager : NSObject {
    
    var data: Data?
    
    var feedUrlString: String
    
    // Number of MB max cache storage space for Images
    let kMaxDiskCacheSizeMegabytes: UInt = 500
    
    // Number of days to keep Images in cache
    let kMaxCachePeriodInDays: Double = 7.0
    
    public var photoArray: Array<PhotoDataObject> = Array<PhotoDataObject>()
    
    public var photoArrayCursorIndex = 0
    public var photoArrayCursorFetchSize = 100
    public var photoArrayWithCursor: Array<PhotoDataObject> = Array<PhotoDataObject>()
    
    init(urlString: String) {
        
        feedUrlString = urlString
        super.init()
        
        ImageCache.default.maxDiskCacheSize = 1024 * 1024 * kMaxDiskCacheSizeMegabytes
        ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * kMaxCachePeriodInDays
    }
    
    public static let sharedInstance = PhotoDataManager(urlString: "http://jsonplaceholder.typicode.com/photos")
    
    public static func sharedInstanceWith(urlString: String) -> PhotoDataManager {
        let instance = PhotoDataManager.sharedInstance
        instance.feedUrlString = urlString
        return instance
    }
    
    public func fetchPhotoData(completion: @escaping (Array<PhotoDataObject>?, Error?) -> Void)  {
        
        Alamofire.request(feedUrlString).responseArray { (response: DataResponse<[PhotoDataObject]>) in
            
            switch response.result {
            case .success:
                if let tempPhotoArray = response.result.value {
                    self.photoArray = tempPhotoArray
                    
//                    let slice = tempPhotoArray[0...601]
//                    self.photoArray = Array(slice)
                }
                completion(self.photoArray,nil)
            case .failure(let error):
                completion(self.photoArray,error)
            }
        }
    }
    
    public func prefetchPhotoImages(completion: @escaping (_ completedResources: [Resource]) -> Void) {
        
        let imageUrlArray = self.photoArray.map { URL(string: $0.thumbnailUrlString!)!
            
        }
        
//        let slice = imageUrlArray[0...10]
//        let array = Array(slice)
        
        let prefetcher = ImagePrefetcher(urls: imageUrlArray, options: nil, progressBlock: { (skippedResources, failedResources, completedResources) in
            //print("Prefetched: \(skippedResources.count) \(failedResources.count) \(completedResources.count) ")
            
        }, completionHandler: { (skippedResources, failedResources, completedResources) in
            print("Prefetched: \(skippedResources.count) \(failedResources.count) \(completedResources.count) ")
            //print("These resources are prefetched: \(completedResources)")
            completion(completedResources)
            
        })

        prefetcher.start()
        print()
    }
    
    public func fetchImage(urlString: String, completion: @escaping (_ image: UIImage?) -> Void) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) {
            image, cacheType in
            if let _ = image {
                // Image is already downloaded
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                
                // Download image and store it in cache
                if let url = URL(string:urlString) {
                    ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
                        (image, error, url, data) in
                        if let image = image {
                            ImageCache.default.store(image, forKey: urlString)
                        }
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                } else {
                    // In this case image should be nil
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    
    public func fetchPhotoDataWithCursor(completion: @escaping (Array<PhotoDataObject>?, Error?) -> Void)  {
        
        if self.photoArrayCursorIndex >= (self.photoArray.count - 1) {
            completion(self.photoArrayWithCursor,nil)
            return
        }
        
        var toIndex = self.photoArrayCursorIndex+self.photoArrayCursorFetchSize
        if toIndex > (self.photoArray.count - 1) {
            toIndex = self.photoArray.count
        }
        
        let slice = self.photoArray[self.photoArrayCursorIndex..<toIndex]
        print("fetchPhotoDataWithCursor >> \(self.photoArrayCursorIndex)..<\(toIndex)")
        
        self.photoArrayCursorIndex = self.photoArrayCursorIndex+self.photoArrayCursorFetchSize
        let array = Array(slice)
    
        self.photoArrayWithCursor.append(contentsOf: array)
        
        completion(self.photoArrayWithCursor, nil)
    }
    
    public func clearImageCache() {
        // Clear memory cache right away.
        ImageCache.default.clearMemoryCache()
        
        // Clear disk cache. This is an async operation.
        ImageCache.default.clearDiskCache()
        
        // Clean expired or size exceeded disk cache. This is an async operation.
        ImageCache.default.cleanExpiredDiskCache()
    }

}
