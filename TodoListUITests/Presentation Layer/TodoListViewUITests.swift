//
//  TodoListViewTests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 13/07/2021.
//

import XCTest
@testable import TodoList

final class TodoListViewTests: XCTestCase {
    private var application: XCUIApplication?
    private let navigationBarTitle = "Todo List"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        application?.launch()
    }
    
    func test_navigation_bar_exist() throws {
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        
        XCTAssert(navigationBar.exists, "The navigation bar does not exist")
    }
    
    func test_navigation_bar_button_exist() throws {
        let navigationBarButtonIcon = "add"
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        let button = navigationBar.buttons[navigationBarButtonIcon].firstMatch
        
        XCTAssert(button.exists, "The navigation bar button not exist")
    }
    
    func test_open_add_new_item_alert() throws {
        let navigationBarButtonIcon = "add"
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        let button = navigationBar.buttons[navigationBarButtonIcon].firstMatch
        
        button.tap()
        let alertTitle = "Add New Item"
        let alertTitleLabel = try XCTUnwrap(application).staticTexts[alertTitle]
        
        XCTAssert(alertTitleLabel.exists, "The \(alertTitle) alert did not open")
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
