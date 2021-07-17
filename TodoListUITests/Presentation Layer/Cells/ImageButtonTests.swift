//
//  ImageButtonTests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class ImageButtonTests: XCTestCase {
    private var application: XCUIApplication?
    private let navigationBarTitle = "Todo List"
    private let navigationBarButtonIcon = "add"
    
    var imageButton: XCUIElement?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        application?.launch()
        
        let navigationBar = application?.navigationBars[navigationBarTitle]
        imageButton = navigationBar?.buttons[navigationBarButtonIcon].firstMatch
    }
    
    func test_image_button_exist() throws {
        let imageButton = try XCTUnwrap(imageButton)
        
        XCTAssert(imageButton.exists)
    }
    
    override func tearDown() {
        imageButton = nil
        application = nil
        super.tearDown()
    }
}
