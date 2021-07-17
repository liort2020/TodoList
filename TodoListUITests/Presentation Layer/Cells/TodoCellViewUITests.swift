//
//  ImageButtonUITests.swift
//  TodoListUITests
//
//  Created by Lior Tal on 13/07/2021.
//

import XCTest
@testable import TodoList

final class ImageButtonUITests: XCTestCase {
    private var application: XCUIApplication?
    
    // TODO: - remove this
//    private let runningUITests = "IS_RUNNING_UITESTS"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        
        // TODO: - remove this
//        application?.launchArguments.append(runningUITests)
        
        
        application?.launch()
    }
    
    func test_() throws {
//        ImageButton(buttonTapped: <#T##Binding<Bool>#>, buttonIcon: <#T##String#>, buttonFont: <#T##Font#>)
        
        //        let alertTitleLabel = try XCTUnwrap(application).staticTexts[alertTitle]

        
        
        
        XCTFail("TODO: - check if we have UI test to this button !!!!!!!!!!!!!!!!!!!!")
        
        XCTFail("TODO: - accessibility for all UI Tests")
        
        // TODO: - check if we have UI test to this button !!!!!!!!!!!!!!!!!!!!
        
        // TODO: - accessibility for all UI Tests
        
        
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}

/*
 let textLabel = application?.staticTexts.element
 let textField = application?.textFields.element
 let buttons = application?.buttons.element

 print("🇺🇸 textLabel: \(textLabel)")
 print("🇺🇸 textField: \(textField)")
 print("🇺🇸 buttons: \(buttons)")
 */
