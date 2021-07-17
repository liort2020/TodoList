//
//  TextFieldAlertUITests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 16/07/2021.
//  Copyright © 2021 Lior Tal. All rights reserved.
//

import XCTest
@testable import TodoList

final class TextFieldAlertUITests: XCTestCase {
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
    
    func test_ok_button() throws {
        let okButton = try XCTUnwrap(application).buttons[okButtonTitle]
        guard okButton.exists else {
            XCTFail("OK button does not exist")
            return
        }
        
        okButton.tap()
        XCTAssertFalse(okButton.exists, "When we tapped the ok button, the alert should be close")
    }
    
    func test_cancel_button() throws {
        let cancelButton = try XCTUnwrap(application).buttons[cancelButtonTitle]
        guard cancelButton.exists else {
            XCTFail("Cancel button does not exist")
            return
        }
        
        cancelButton.tap()
        XCTAssertFalse(cancelButton.exists, "When we tapped the cancel button, the alert should be close")
    }
    
    func test_input_title() throws {
        let textField = try XCTUnwrap(application).textFields.element.firstMatch
        guard textField.exists else {
            XCTFail("Text field does not exist")
            return
        }
        
        let inputText = "New Title"
        textField.typeText(inputText)
        let textFieldValue = try XCTUnwrap(textField.value as? String)
        
        XCTAssertEqual(textFieldValue, inputText, "Expected value in the text field is: \(inputText) instead of: \(textFieldValue)")
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
