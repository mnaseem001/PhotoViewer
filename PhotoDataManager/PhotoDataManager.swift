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
    
    var photoArray: Array<PhotoDataObject>? = Array<PhotoDataObject>()
    
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
            if let error = response.result.error {
                // got an error while deleting, need to handle it
                print("error calling DELETE on /todos/1")
                print(error)
                completion(nil,error)
            } else {
                self.photoArray = response.result.value
                completion(response.result.value,nil)
            }

        }
    }

}
