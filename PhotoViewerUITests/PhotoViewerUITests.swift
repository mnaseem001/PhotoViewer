//
//  PhotoViewerUITests.swift
//  PhotoViewerUITests
//
//  Created by Mansoor Naseem on 6/13/17.
//  Copyright © 2017 Mansoor Naseem. All rights reserved.
//

import XCTest

class PhotoViewerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhotoViewerTableView() {

        // This is just a wait before Data in Table View Loads
        
        // DISCLAIMER NOTE: These tests can and will fail at times.
        // This is just to show data in the labels can be tested.
        // However, it is not a good idea for real life since data
        // often changes and loading of same data in the tables can
        // be in different order.
        
        
        
        let app = XCUIApplication()
        
        let exists = NSPredicate(format: "exists == 1")
        var cell = app.tables.element.cells.element(boundBy: 0)

        // Expectation is that at least cell at row 0 exists in 5 seconds
        expectation(for: exists, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                assertionFailure("error")
            }
        }


        // Below are test to show that values in labels can be tested
        // This test value is checking if text is same for the cell label
        var photoStaticText = "ID: 100 - Album ID: 2"
        
        // Using accessibilityIdentifier to get the ID Label
        var PhotoIdLabel = cell.staticTexts["PhotoId"]
        XCTAssertEqual(photoStaticText, PhotoIdLabel.label)
        
        
        // All the repeating code can be in one for loop and
        // in a function like the next testing method.
        
        cell = app.tables.element.cells.element(boundBy: 1)
        photoStaticText = "ID: 99 - Album ID: 2"
        PhotoIdLabel = cell.staticTexts["PhotoId"]
        XCTAssertEqual(photoStaticText, PhotoIdLabel.label)
        
        cell = app.tables.element.cells.element(boundBy: 2)
        photoStaticText = "ID: 98 - Album ID: 2"
        PhotoIdLabel = cell.staticTexts["PhotoId"]
        XCTAssertEqual(photoStaticText, PhotoIdLabel.label)
        
        cell = app.tables.element.cells.element(boundBy: 3)
        photoStaticText = "ID: 97 - Album ID: 2"
        PhotoIdLabel = cell.staticTexts["PhotoId"]
        XCTAssertEqual(photoStaticText, PhotoIdLabel.label)
        
        cell = app.tables.element.cells.element(boundBy: 4)
        photoStaticText = "ID: 96 - Album ID: 2"
        PhotoIdLabel = cell.staticTexts["PhotoId"]
        XCTAssertEqual(photoStaticText, PhotoIdLabel.label)
        
        cell = app.tables.element.cells.element(boundBy: 5)
        photoStaticText = "ID: 95 - Album ID: 2"
        PhotoIdLabel = cell.staticTexts["PhotoId"]
        XCTAssertEqual(photoStaticText, PhotoIdLabel.label)
        
        sleep(10)
        
        
        
    }
    
    // Snippet of code that finds a cell and Taps it
    func waitForCellToAppearAndThenTapIt(cellId: UInt) {
        let exists = NSPredicate(format: "exists == 1")
        let cell = XCUIApplication().tables.element.cells.element(boundBy: cellId)
        
        expectation(for: exists, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                assertionFailure("error")
            }
        }
        
        cell.tap()
    }
    
    
    // Snippet of code that finds Back Button and taps it
    func waitForBackButtonToAppearThenTapIt() {
        
        let exists = NSPredicate(format: "exists == 1")
        let backButton = XCUIApplication().navigationBars["PhotoViewer.PhotoViewDetailView"].buttons["Photos"]
        expectation(for: exists, evaluatedWith: backButton, handler: nil)
        waitForExpectations(timeout: 1) { error in
            if error != nil {
                assertionFailure("error")
            }
        }
        
        backButton.tap()
    }
    
    func testPhotoViewerDetail() {
        // This is to show test if table cell loads
        // And when tapped a Detail Photo Info Screen
        // comes up.  The back button shows that a detail
        // screen successfully came up.  There can even
        // more fine grained tests that make sure
        // the labels exist and have some valid data.
        waitForCellToAppearAndThenTapIt(cellId: 0)
        waitForBackButtonToAppearThenTapIt()
        waitForCellToAppearAndThenTapIt(cellId: 1)
        waitForBackButtonToAppearThenTapIt()
        waitForCellToAppearAndThenTapIt(cellId: 2)
        waitForBackButtonToAppearThenTapIt()
        waitForCellToAppearAndThenTapIt(cellId: 3)
        waitForBackButtonToAppearThenTapIt()
        waitForCellToAppearAndThenTapIt(cellId: 4)
        waitForBackButtonToAppearThenTapIt()
        waitForCellToAppearAndThenTapIt(cellId: 5)
        waitForBackButtonToAppearThenTapIt()
        
        // Sleep is never a great idea in UI Testing because
        // it hangs the Actual App as well as the harness. This
        // is only so one can see the Screen longer and 
        // Testing does not shutdown abruptly.
        sleep(5)
    }
    
}
