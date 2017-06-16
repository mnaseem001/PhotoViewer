//
//  PhotoDataManagerConstants.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/15/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import Foundation

public struct PhotoDataManagerConstants {
    
    // Main URL to fetch Json data
    public static let kDefaultPhotoServerUrlString = "http://jsonplaceholder.typicode.com/photos"
    
    // Notification for fetching PhotoArray
    public static let kNotificationFetchedPhotoArraySuccess = "kNotificationFetchedPhotoArraySuccess"
    public static let kNotificationFetchedPhotoArrayFailure = "kNotificationFetchedPhotoArrayFailure"
    
    // Notification for fetching CursorPhotoArray
    public static let kNotificationFetchedCursorPhotoArraySuccess = "kNotificationFetchedCursorPhotoArraySuccess"
    public static let kNotificationFetchedCursorPhotoArrayFailure = "kNotificationFetchedCursorPhotoArrayFailure"
    
}
