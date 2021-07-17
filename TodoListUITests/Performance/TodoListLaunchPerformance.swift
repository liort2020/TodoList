//
//  TodoListLaunchPerformance.swift
//  TodoListUITests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest

class TodoListLaunchPerformance: XCTestCase {
    private var application: XCUIApplication?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            application?.launch()
        }
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
