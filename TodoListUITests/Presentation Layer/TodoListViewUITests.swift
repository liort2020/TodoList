//
//  TodoListViewUITests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class TodoListViewUITests: XCTestCase {
    private var application: XCUIApplication?
    private let navigationBarTitle = "Todo List"
    private let navigationBarButtonIcon = "add"
    private let alertTitle = "Add New Item"
    
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
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        let button = navigationBar.buttons[navigationBarButtonIcon].firstMatch
        
        XCTAssert(button.exists, "The navigation bar button not exist")
    }
    
    func test_open_add_new_item_alert() throws {
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        let button = navigationBar.buttons[navigationBarButtonIcon].firstMatch
        
        button.tap()
        let alertTitleLabel = try XCTUnwrap(application).staticTexts[alertTitle]
        
        XCTAssert(alertTitleLabel.exists, "The \(alertTitle) alert did not open")
    }
    
    func test_list_exist() throws {
        let todoList = try XCTUnwrap(application).tables.firstMatch
        
        XCTAssert(todoList.exists)
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
