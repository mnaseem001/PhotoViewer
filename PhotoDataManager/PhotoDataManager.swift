//
//  PhotoDataManager.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/13/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Kingfisher

public class PhotoDataManager : NSObject {
    
    var data: Data?
    
    var feedUrlString: String
    
    // Number of MB max cache storage space for Images
    let kMaxDiskCacheSizeMegabytes: UInt = 500
    
    // Number of days to keep Images in cache
    let kMaxCachePeriodInDays: Double = 7.0
    
    init(urlString: String) {
        
        feedUrlString = urlString
        super.init()
        
        ImageCache.default.maxDiskCacheSize = 1024 * 1024 * kMaxDiskCacheSizeMegabytes
        ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * kMaxCachePeriodInDays
    }

}
