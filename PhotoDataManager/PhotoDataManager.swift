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
    
    var feedUrlString: String
    
    // Number of MB max cache storage space for Images
    let kMaxDiskCacheSizeMegabytes: UInt = 500
    
    // Number of days to keep Images in cache
    let kMaxCachePeriodInDays: Double = 7.0
    
    public var photoArray: Array<PhotoDataObject> = Array<PhotoDataObject>()
    
    // This is an initial max Int number to make sure photo data is fetch on first call
    // Subsequently the size will be changed to actual size
    // Note: "FETCHED" Size 
    //
    var photoArrayFetchedSize = Int.max
    
    public var photoArrayCursorIndex = 0
    
    // Album ID's look like they are 50
    public var photoArrayCursorFetchSize = 100
    public var photoArrayWithCursor: Array<PhotoDataObject> = Array<PhotoDataObject>()
    var photoArrayCursorFetchingInProgress = false
    
    let thumbnailImagesfetchSize = 200
    var fetchIndex = 0
    
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
        
        // No need to fetch if last fetch size is equal to size of actual size
        // Technically it could be just greater than zero
        if self.photoArray.count == self.photoArrayFetchedSize {
            completion(self.photoArray,nil)
            return
        }
        
        Alamofire.request(feedUrlString).responseArray { (response: DataResponse<[PhotoDataObject]>) in
            
            // Reset photoArrayWithCursor
            self.resetPhotoArrayCursor()
            
            switch response.result {
            case .success:
                if let tempPhotoArray = response.result.value {
                    self.photoArray = tempPhotoArray
                    self.photoArrayFetchedSize = self.photoArray.count
                    self.fetchIndex = 0
                    
                }
                completion(self.photoArray,nil)
                NotificationCenter.default.post(name: Notification.Name(PhotoDataManagerConstants.kNotificationFetchedPhotoArraySuccess), object: nil)
            case .failure(let error):
                completion(self.photoArray,error)
                NotificationCenter.default.post(name: Notification.Name(PhotoDataManagerConstants.kNotificationFetchedPhotoArrayFailure), object: nil)
            }
        }
    }
    

    public func loadImages(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async {
            
            if self.fetchIndex >= (self.photoArray.count - 1 ) {
                
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            var toIndex = self.fetchIndex+self.thumbnailImagesfetchSize
            if toIndex > (self.photoArray.count - 1) {
                toIndex = self.photoArray.count
            }
            let slice = self.photoArray[self.fetchIndex..<toIndex]
            
            // loadImages from self.fetchIndex to toIndex
            let array = Array(slice)
            let imageUrlArray = array.map { URL(string: $0.thumbnailUrlString!)! }
            self.fetchIndex = self.fetchIndex+self.thumbnailImagesfetchSize
            
            self.prefetchPhotoImages(imageUrlArray: imageUrlArray, completion: { (completedResource) in
                // Custom code if necessary
                self.loadImages(completion: { 
                    // Empty block
                    completion()
                })
            })
        }

        
    }
    
    public func prefetchPhotoImages(imageUrlArray: Array<URL>, completion: @escaping (_ completedResources: [Resource]) -> Void) {

        let prefetcher = ImagePrefetcher(urls: imageUrlArray, options: nil, progressBlock: { (skippedResources, failedResources, completedResources) in
            
            // Comment out to see the progress
            //print("Prefetched: \(skippedResources.count) \(failedResources.count) \(completedResources.count) ")
            
        }, completionHandler: { (skippedResources, failedResources, completedResources) in
            
            // Comment out to see result of prefecter
            //print("Prefetched: \(skippedResources.count) \(failedResources.count) \(completedResources.count) ")
            completion(completedResources)
            
        })

        prefetcher.start()

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
        
        if self.photoArray.isEmpty {
            
            fetchPhotoData(completion: { (array, error) in
                self.fetchPhotoDataWithCursorInternal(completion: { (cursorArray, cursorError) in
                    completion(cursorArray, cursorError)
                })
            })
        } else {
            
            self.fetchPhotoDataWithCursorInternal(completion: { (cursorArray, cursorError) in
                completion(cursorArray, cursorError)
            })

        }

    }
    
    fileprivate func fetchPhotoDataWithCursorInternal(completion: @escaping (Array<PhotoDataObject>?, Error?) -> Void)  {
    
        DispatchQueue.global(qos: .default).async {
            if self.photoArrayCursorIndex >= (self.photoArray.count - 1) {
                completion(self.photoArrayWithCursor,nil)
                return
            }
            
            var toIndex = self.photoArrayCursorIndex+self.photoArrayCursorFetchSize
            if toIndex > (self.photoArray.count - 1) {
                toIndex = self.photoArray.count
            }
            
            let slice = self.photoArray[self.photoArrayCursorIndex..<toIndex]
            
            // index is now moved to the TO Index
            self.photoArrayCursorIndex = self.photoArrayCursorIndex+self.photoArrayCursorFetchSize
            let array = Array(slice)
            self.photoArrayWithCursor.append(contentsOf: array)
            let reversedArray = Array(self.photoArrayWithCursor.reversed())
            DispatchQueue.main.async {
                completion(reversedArray, nil)
                NotificationCenter.default.post(name: Notification.Name(PhotoDataManagerConstants.kNotificationFetchedCursorPhotoArraySuccess), object: nil)
            }
            
        }
    }
    
    
    public func clearImageCache() {
        // Clear memory cache right away.
        ImageCache.default.clearMemoryCache()
        
        // Clear disk cache. This is an async operation.
        ImageCache.default.clearDiskCache()
        
        // Clean expired or size exceeded disk cache. This is an async operation.
        ImageCache.default.cleanExpiredDiskCache()
    }
    
    public func resetPhotoArrayCursor() {
        // Reset photoArrayWithCursor
        self.photoArrayCursorIndex = 0
        
        // This will remove all objects
        self.photoArrayWithCursor.removeAll()
    }

}
