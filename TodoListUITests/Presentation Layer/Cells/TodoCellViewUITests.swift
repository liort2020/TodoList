//
//  TodoCellViewUITests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class TodoCellViewUITests: XCTestCase {
    private var application: XCUIApplication?
    private let deleteButtonTitle = "Delete"
    
    private var todoCell: XCUIElement?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        application?.launch()
        
        todoCell = application?.tables.firstMatch.cells.firstMatch
    }
    
    func test_cell_exist() throws {
        let todoCell = try XCTUnwrap(todoCell)
        
        XCTAssert(todoCell.exists)
    }
    
    func test_swipe_to_delete() throws {
        let todoCell = try XCTUnwrap(todoCell)
        
        todoCell.swipeLeft()
        let deleteButton = todoCell.buttons[deleteButtonTitle]
        
        XCTAssert(deleteButton.exists)
    }
    
    override func tearDown() {
        todoCell = nil
        application = nil
        super.tearDown()
    }
}
