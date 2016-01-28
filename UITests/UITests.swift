//
//  UITests.swift
//  UITests
//
//  Created by Tomas Kohout on 1/28/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        
        //Setup snapshots
        setupSnapshot(app)
        
        
        
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainScreen() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["2880 x 2754"].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(46).childrenMatchingType(.StaticText).matchingIdentifier("6016 x 4016").elementBoundByIndex(0).pressForDuration(0.4);
        
        snapshot("01MainScreen")
    }
    
}
