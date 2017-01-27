//
//  UITests.swift
//  UITests
//
//  Created by Tomas Kohout on 1/28/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import XCTest
import Nimble

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
        
        let app = XCUIApplication()
        
        //Wait for pictures to load
        //let images = app.images
        
        
        expect(app.tables.cells).toEventuallyNot(beNil(), timeout:20)
        expect(app.images).toEventuallyNot(beNil(), timeout:20)
        
        
        //Tap the allow location popup
        if (app.alerts.count > 0) {
            app.alerts.element(boundBy: 0).buttons.element(boundBy: 1).tap()
        }
        
        snapshot("01MainScreenList")
        
        let tablesQuery = app.tables
        tablesQuery.cells.element(boundBy: 0).tap()
        
        snapshot("02DetailScreenFirst")
        
        let backButton = app.navigationBars["ProjectSkeleton.LanguageDetailView"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0)
        backButton.tap()
        
        
        tablesQuery.cells.element(boundBy: 1).tap()
        
        snapshot("03DetailScreenSecond")
        
        backButton.tap()
        
    }
    
}
