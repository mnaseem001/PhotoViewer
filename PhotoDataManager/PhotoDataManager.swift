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
    
    init(urlString: String) {
        
        feedUrlString = urlString
        super.init()
        
        ImageCache.default.maxDiskCacheSize = 1024 * 1024 * kMaxDiskCacheSizeMegabytes
        ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * kMaxCachePeriodInDays
    }
    
    static let sharedInstance = PhotoDataManager(urlString: "http://jsonplaceholder.typicode.com/photos")
    
    public static func sharedInstanceWith(urlString: String) -> PhotoDataManager {
        let instance = PhotoDataManager.sharedInstance
        instance.feedUrlString = urlString
        return instance
    }
    
    public func fetchPhotoData(completion: @escaping (Array<PhotoDataObject>?, Error?) -> Void)  {
        
        Alamofire.request(feedUrlString).responseArray { (response: DataResponse<[PhotoDataObject]>) in
            
            switch response.result {
            case .success:
                if let array = response.result.value {
                    self.photoArray = array
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
        
        let slice = imageUrlArray[0...10]
        let array = Array(slice)
        
        let prefetcher = ImagePrefetcher(urls: array, options: nil, progressBlock: { (skippedResources, failedResources, completedResources) in
            //print("Prefetched: \(skippedResources.count) \(failedResources.count) \(completedResources.count) ")
            
        }, completionHandler: { (skippedResources, failedResources, completedResources) in
            print("Prefetched: \(skippedResources.count) \(failedResources.count) \(completedResources.count) ")
            //print("These resources are prefetched: \(completedResources)")
            completion(completedResources)
            
        })

        prefetcher.start()
        print()
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
