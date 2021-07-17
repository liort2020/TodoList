//
//  TextFieldAlertTests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 13/07/2021.
//

import XCTest
@testable import TodoList

final class TextFieldAlertTests: XCTestCase {
    private var application: XCUIApplication?
    private let navigationBarTitle = "Todo List"
    private let navigationBarButtonIcon = "add"
    private let alertTitle = "Add New Item"
    private let placeholder = "Enter Task"
    private let okButtonTitle = "OK"
    private let cancelButtonTitle = "Cancel"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        application?.launch()
        let navigationBar = application?.navigationBars[navigationBarTitle]
        let button = navigationBar?.buttons[navigationBarButtonIcon].firstMatch
        button?.tap()
    }
    
    func test_open_add_new_item_alert() throws {
        let alertTitleLabel = try XCTUnwrap(application).staticTexts[alertTitle]
        
        XCTAssert(alertTitleLabel.exists, "The \(alertTitle) alert did not open")
    }
    
    func test_text_field_placeholder() throws {
        let alertTextLabel = try XCTUnwrap(application).textFields[placeholder]
        
        XCTAssert(alertTextLabel.exists, "Placeholder does not exist")
    }
    
    func test_alert_buttons() throws {
        let oKbutton = try XCTUnwrap(application).buttons[okButtonTitle]
        let cancelbutton = try XCTUnwrap(application).buttons[cancelButtonTitle]
        
        XCTAssert(oKbutton.exists, "OK button does not exist")
        XCTAssert(cancelbutton.exists, "Cancel button does not exist")
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
