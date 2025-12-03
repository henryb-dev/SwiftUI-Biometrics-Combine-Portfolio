//
//  AddressUITests.swift
//  AddressUITests
//
//  Created by Henry Bautista on 22/07/25.
//

import XCTest

final class AddressUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testLoginViewUI() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-uiTest_loginView")
        app.launch()
        XCTAssertTrue(app.staticTexts["Admin Login"].exists)
        let loginButton = app.buttons["touchFaceIdButton"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        app.launchArguments.append("-uiTest_biometricSuccess")
        let homeText = app.staticTexts["Direcciones"]
        XCTAssertTrue(homeText.waitForExistence(timeout: 2))
    }

    @MainActor
    func testLaunchPerformance() throws {
    #if !DEBUG
    measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
    }
    #endif
    }
}
