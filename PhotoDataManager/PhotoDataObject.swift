//
//  PhotoDataObject.swift
//  PhotoViewer
//
//  Created by Mansoor Naseem on 6/13/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import Foundation
import ObjectMapper

public struct PhotoDataObject: Mappable {
    
    public var albumId: NSNumber?
    public var feedObjectId: NSNumber?
    public var title: String?
    public var urlString: String?
    public var thumbnailUrlString: String?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        albumId 	<- map["albumId"]
        feedObjectId 	<- map["id"]
        title 	<- map["title"]
        urlString 	<- map["url"]
        thumbnailUrlString 	<- map["thumbnailUrl"]
    }
}
