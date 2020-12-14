//
//  ChatTests.swift
//  Customerly

import XCTest

class ChatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewConversation() {
        let app = XCUIApplication()
        app.buttons["Register User"].tap()
        app.buttons["Open Chat"].tap()
        app.buttons["Start a new conversation"].tap()
        
        let askYourQuestionTextField = app.textFields["Ask your question"]
        askYourQuestionTextField.tap()
        askYourQuestionTextField.typeText("Hi! How are you? This message is sent from UI Test!")
        app.buttons["Button"].tap()
        app.navigationBars["Chat"].buttons["Support"].tap()
        app.navigationBars["Support"].children(matching: .button).element.tap()
    }
    
    func testOpenAnExistingConversationAndChat(){
        let app = XCUIApplication()
        app.buttons["Register User"].tap()
        app.buttons["Open Chat"].tap()
        
        let firstChild = app.tables.cells.element(boundBy: 0)
        firstChild.tap()
        let askYourQuestionTextField = app.textFields["Ask your question"]
        askYourQuestionTextField.tap()
        askYourQuestionTextField.typeText("All ok? Sent from UI Test")
        app.buttons["Button"].tap()
        app.navigationBars["Chat"].buttons["Support"].tap()
        app.navigationBars["Support"].children(matching: .button).element.tap()
        
    }
}
