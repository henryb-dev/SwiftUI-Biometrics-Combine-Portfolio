//
//  PersistenceControllerTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//

import XCTest
import CoreData
@testable import Address

final class PersistenceControllerTests: XCTestCase {

    func testInMemoryStoreLoadsCorrectly() {
        let persistence = PersistenceController(inMemory: true)
        let ctx = persistence.container.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Address", in: ctx)
        XCTAssertNotNil(entity)
    }
}
