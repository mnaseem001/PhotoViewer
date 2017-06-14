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
    
    // http://jsonplaceholder.typicode.com/photos is serving exactly 5000 records
    let kPhotoDataArraySizeOnServer = 5000
    
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
        
        manager.fetchPhotoData { (photoDataArray, error) in

            // Test if there are no errors fetching data
            //  Fail testFetchPhotoData()
            if let error = error {
                XCTFail("fetchPhotoData failed.  Error: \(error.localizedDescription)")
            }

            // Test if photoDataArray is not nil
            //  photoDataArray should never be nil even if there was no data fetched. Even if HTTP Call failed.
            //  This will only occur if ObjectMapper fails for some reason and returns a nil.
            //  Exit if photoDataArray because there is no need to do further tests
            //  Fail testFetchPhotoData()
            if photoDataArray == nil {
                XCTFail("photoDataArray should never be nil.")
                fetchExpectation.fulfill()
                return
            }
            
            // Test if fetched photoDataArray is not empty
            XCTAssertTrue(photoDataArray!.count > 0, "Photo Data fetch failed or server suddenly is has no data.")
            
            // Text if fetched photoDataArray has 5000 records
            XCTAssertTrue(photoDataArray!.count == self.kPhotoDataArraySizeOnServer, "Photo Data fetch failed or server suddenly is has no data.")
            
            
            // Test if an object in photoDataArray is a PhotoDataObject
            //
            let object = photoDataArray?[0]
            XCTAssertTrue((object as Any) is PhotoDataObject, "Objects from photoDataArray should be PhotoDataObject types")
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
