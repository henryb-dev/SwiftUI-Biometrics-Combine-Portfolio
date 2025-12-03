//
//  AddressListViewUITests.swift
//  Address
//
//  Created by Henry Bautista on 2/12/25.
//


import XCTest
import CoreData
@testable import Address


final class AddressListViewUITests: XCTestCase {
    
    var ctx: NSManagedObjectContext!

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("-uiTest_addressList")
        app.launch()
        let loginButton = app.buttons["touchFaceIdButton"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        app.launchArguments.append("-uiTest_biometricSuccess")
        let homeText = app.staticTexts["Direcciones"]
        XCTAssertTrue(homeText.waitForExistence(timeout: 2))
        return app
    }

    @MainActor
    func testAddressListDisplaysItems() throws {
        let app = launchApp()
        app.launchArguments.append("-uiTest_addressList")
        
        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))


    }

    @MainActor
    func testSearchFiltersResults() throws {
        let app = launchApp()

        // Buscar "Miami"
        let search = app.searchFields["buscar"]
        XCTAssertTrue(search.exists)
        search.tap()
        search.typeText("Madr")

        // Verificar que aparece una celda filtrada
        let miamiCell = app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Madr")).firstMatch
        XCTAssertTrue(miamiCell.waitForExistence(timeout: 2))
    }

    @MainActor
    func testTapAddButtonOpensSheet() throws {
        let app = launchApp()

        // Botón +
        let addButton = app.buttons["plus"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()

        // Sheet debería mostrar campos del AddressDetailView
        XCTAssertTrue(app.staticTexts["Detalles"].waitForExistence(timeout: 2))
    }

    @MainActor
    func testDeleteAddress() throws {
        let app = launchApp()
        let cells = app.cells.count
        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()
        XCTAssertFalse(cells <= app.cells.count)
    }
    
    @MainActor
    func testNavigationToDetail() throws {
        let app = launchApp()

        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))

        cell.tap()


        XCTAssertTrue(app.staticTexts["Detalles"].waitForExistence(timeout: 2))
    }
}
