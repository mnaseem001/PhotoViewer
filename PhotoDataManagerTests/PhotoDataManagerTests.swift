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
    
    let kPhotoServerUrlString = "http://jsonplaceholder.typicode.com/photos"
    
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
        let manager = PhotoDataManager.sharedInstanceWith(urlString: kPhotoServerUrlString)
        
        manager.fetchPhotoData { (photoDataArray, error) in

            // Test if there are no errors fetching data
            //  Fail testFetchPhotoData()
            if let error = error {
                XCTAssertTrue(!error.localizedDescription.isEmpty, "Error fetching data.")
                XCTFail("fetchPhotoData failed.  Error: \(error.localizedDescription)")
            }

            // Test if photoDataArray is not nil
            //  photoDataArray should never be nil even if there was no data fetched. Even if HTTP Call failed.
            //  This will only occur if ObjectMapper fails for some reason and returns a nil.
            //  Exit if photoDataArray because there is no need to do further tests
            //  Fail testFetchPhotoData()
            if photoDataArray == nil {
                XCTFail("photoDataArray should never be nil. Exit. No need for further tests.")
                fetchExpectation.fulfill()
                return
            }
            
            // Test if fetched photoDataArray is not empty
            XCTAssertTrue(photoDataArray!.count > 0, "Photo Data fetch failed or server suddenly has no data.")
            if photoDataArray!.count == 0 {
                XCTFail("photoDataArray is empty. No need for further tests.")
                return
            }
            
            // Text if fetched photoDataArray has 5000 records
            //XCTAssertTrue(photoDataArray!.count == self.kPhotoDataArraySizeOnServer, "Photo Data fetch failed or server suddenly is has no data.")
            
            // Test if an object in photoDataArray is a PhotoDataObject
            //
            let object = photoDataArray?[0]
            XCTAssertTrue((object as Any) is PhotoDataObject, "Objects from photoDataArray should be PhotoDataObject types")
            fetchExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0) { (error) in
            
        }
    }
    
    func fetchPhotoDataWithCursor(cursorExpectation: XCTestExpectation) {
        
        let manager = PhotoDataManager.sharedInstanceWith(urlString: kPhotoServerUrlString)
        
        manager.fetchPhotoDataWithCursor { (cursorArray, error) in
            
            if cursorArray?.count == 0 {
                print("cursorArray?.count == 0")
                XCTFail("cursorArray cannot be empty")
                return
            } else if cursorArray?.count == manager.photoArray.count {
                print("exit because you hit the end")
                // this is good
                // exit because you hit the end
                cursorExpectation.fulfill()
                return
            } else if (cursorArray?.count)! > manager.photoArray.count {
                XCTFail("How can cursorArray?.count (\(cursorArray?.count)) > manager.photoArray.count\(manager.photoArray.count). Something wrong with fetch cursor algorithm.")
                print("ELSE (cursorArray?.count)! > manager.photoArray.count>> cursorArray?.count = \(cursorArray?.count)")
                // something seriously went wrong
                return
            } else {
                print("ELSE >> cursorArray?.count = \(cursorArray?.count)")
                self.fetchPhotoDataWithCursor(cursorExpectation: cursorExpectation)
            }
            
        }

        
    }
    
    func testFetchPhotoDataWithCursor() {
        let cursorExpectation = expectation(description: "Completion handler when data is fetched using cursor")
        fetchPhotoDataWithCursor(cursorExpectation: cursorExpectation)
        
        waitForExpectations(timeout: 10.0) { (error) in
            
        }
    }
    
//    func testFetchPhotoDataWithCursor() {
//        
//        let fetchExpectation = expectation(description: "Completion handler when data is fetched")
//        let manager = PhotoDataManager.sharedInstanceWith(urlString: kPhotoServerUrlString)
//        
//        manager.fetchPhotoDataWithCursor { (photoDataArray, error) in
//            
//            // Test if there are no errors fetching data
//            //  Fail testFetchPhotoData()
//            if let error = error {
//                XCTAssertTrue(!error.localizedDescription.isEmpty, "Error fetching data.")
//                XCTFail("fetchPhotoData failed.  Error: \(error.localizedDescription)")
//            }
//            
//            // Test if photoDataArray is not nil
//            //  photoDataArray should never be nil even if there was no data fetched. Even if HTTP Call failed.
//            //  This will only occur if ObjectMapper fails for some reason and returns a nil.
//            //  Exit if photoDataArray because there is no need to do further tests
//            //  Fail testFetchPhotoData()
//            if photoDataArray == nil {
//                XCTFail("photoDataArray should never be nil. Exit. No need for further tests.")
//                fetchExpectation.fulfill()
//                return
//            }
//            
//            // Test if fetched photoDataArray is not empty
//            XCTAssertTrue(photoDataArray!.count > 0, "Photo Data fetch failed or server suddenly has no data.")
//            if photoDataArray!.count == 0 {
//                XCTFail("photoDataArray is empty. No need for further tests.")
//                return
//            }
//            
//            // Text if fetched photoDataArray has 5000 records
//            XCTAssertTrue(photoDataArray!.count == manager.photoArrayCursorFetchSize, "Photo Data fetch failed or server suddenly is has no data.")
//            
//            // Test if an object in photoDataArray is a PhotoDataObject
//            //
//            let object = photoDataArray?[0]
//            XCTAssertTrue((object as Any) is PhotoDataObject, "Objects from photoDataArray should be PhotoDataObject types")
//            fetchExpectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 10.0) { (error) in
//            
//        }
//    }
    
    func testFetchPhotoImages() {

        let prefectImagesExpectation = expectation(description: "Completion handler when all images are prefetched")
        let manager = PhotoDataManager.sharedInstanceWith(urlString: kPhotoServerUrlString)

        guard manager.photoArray.count > 0 else {
            XCTFail("photoDataArray is empty. No need for further tests.")
            return
        }
        
        // remove all images from cache
        // then do the fetch
        manager.clearImageCache()
        NSLog("START DOWNLOAD");
        manager.loadImages {
            NSLog("END DOWNLOAD");
            prefectImagesExpectation.fulfill()
        }

        
        
        waitForExpectations(timeout: 120.0) { (error) in
            
        }
        
        
    }
    
    func testSingleImageDownloadForThumbnail() {
        
        let fetchImageExpectation = expectation(description: "Completion handler when image is fetched")
        let manager = PhotoDataManager.sharedInstanceWith(urlString: self.kPhotoServerUrlString)
        guard manager.photoArray.count > 0 else {
            XCTFail("photoDataArray is empty. No need for further tests.")
            return
        }
        
        // Test if an object in photoDataArray is a PhotoDataObject
        //
        let photoObject = manager.photoArray[0]
        XCTAssertTrue((photoObject as Any) is PhotoDataObject, "Objects from photoDataArray should be PhotoDataObject types")
        
        
        guard let thumbnailUrl = photoObject.thumbnailUrlString else {
            XCTFail("thumbnailUrl should never be nil. no need to do further testing")
            return
        }
        
        
        manager.fetchImage(urlString: thumbnailUrl) { (image) in
            fetchImageExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { (error) in
            
        }
        
    }
    
    func testSingleImageDownloadForRegularImage() {
        
        let fetchImageExpectation = expectation(description: "Completion handler when image is fetched")
        let manager = PhotoDataManager.sharedInstanceWith(urlString: self.kPhotoServerUrlString)
        guard manager.photoArray.count > 0 else {
            XCTFail("photoDataArray is empty. No need for further tests.")
            return
        }
        
        // Test if an object in photoDataArray is a PhotoDataObject
        //
        let photoObject = manager.photoArray[0]
        XCTAssertTrue((photoObject as Any) is PhotoDataObject, "Objects from photoDataArray should be PhotoDataObject types")
        
        guard let imageUrl = photoObject.urlString else {
            XCTFail("urlString should never be nil. no need to do further testing")
            return
        }
        
        
        manager.fetchImage(urlString: imageUrl) { (image) in
            fetchImageExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { (error) in
            
        }
        
    }
    
    
    
    
    

    func testPerformanceFetchingImages() {
        
        let manager = PhotoDataManager.sharedInstanceWith(urlString: self.kPhotoServerUrlString)
        guard manager.photoArray.count > 0 else {
            XCTFail("photoDataArray is empty. No need for further tests.")
            return
        }
        
        self.measureMetrics(PhotoDataManagerTests.self.defaultPerformanceMetrics(), automaticallyStartMeasuring: true) {
            
            let feedExpectation = self.expectation(description: "Completion handler when data is fetched")

            // remove all images from cache
            // then do the fetch
            //manager.clearImageCache()
            NSLog("START DOWNLOAD");
            manager.loadImages {
                NSLog("END DOWNLOAD");
                feedExpectation.fulfill()
            }
            
            self.waitForExpectations(timeout: 120.0) { (error) in
                self.stopMeasuring()
            }
        }
    }
}
