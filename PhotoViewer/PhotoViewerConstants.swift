//
//  PhotoViewerConstants.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/14/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import Foundation

struct PhotoViewerConstants {
    
    // Main URL to fetch Json data
    static let kPhotoServerUrlString = "http://jsonplaceholder.typicode.com/photos"
    
    // Notification to let observers know initial json has been fetched from server
    static let kNotificationFetchedPhotosDone = "kNotificationFetchedPhotosDone"
    
    // Notification to let observers know initial json fetch has failed
    static let kNotificationFetchedPhotosFailed = "kNotificationFetchedPhotosFailed"
}
