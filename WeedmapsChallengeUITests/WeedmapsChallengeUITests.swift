//
//  WeedmapsChallengeUITests.swift
//  WeedmapsChallengeUITests
//
//  Created by Mark Anderson on 10/5/18.
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import XCTest

class WeedmapsChallengeUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabBarTitleLabelsExist() {
        let app = XCUIApplication()
        XCTAssertTrue(app.staticTexts["Home Title Label"].exists)
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.staticTexts["Favorites Title Label"].exists)
    }
    
    func testHomeViewControllerSetUp() {
        
        
        let app = XCUIApplication()
        let searchBarExists = app.otherElements["Home Search Bar"].exists
        let collectionViewExists = app.collectionViews["Home Collection View"].exists
        
        XCTAssertTrue(searchBarExists)
        XCTAssertTrue(collectionViewExists)
        
        
        
       
        
    }
}
