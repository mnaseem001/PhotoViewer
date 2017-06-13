//
//  PhotoDataManagerTests.swift
//  PhotoDataManagerTests
//
//  Created by Mansoor Naseem on 6/13/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import XCTest
@testable import PhotoDataManager

class PhotoDataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchPhotoData() {

        let fetchExpectation = expectation(description: "Completion handler when data is fetched")
        let manager = PhotoDataManager.sharedInstanceWith(urlString: "http://jsonplaceholder.typicode.com/photos")
        
        manager.fetchPhotoData { (photoDataArray) in
            XCTAssert(photoDataArray != nil, "array should not be nil")
            XCTAssertTrue(photoDataArray!.count > 0, "array should have at least one object")
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0) { (error) in
            
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
