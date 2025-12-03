//
//  AddressTests.swift
//  AddressTests
//
//  Created by Henry Bautista on 22/07/25.
//

import XCTest
import CoreData
@testable import Address

final class AddressTests: XCTestCase {

    var ctx: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "MyAddressAppModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        ctx = container.viewContext
    }

    func testCreateOrUpdateCreatesNewAddress() throws {
        let dto = AddressDTO(id: UUID(),
                             street: "Main St",
                             city: "NY",
                             state: "NY",
                             country: "USA")

        let address = Address.createOrUpdate(from: dto, in: ctx)

        XCTAssertEqual(address.id, dto.id)
        XCTAssertEqual(address.street, "Main St")
        XCTAssertEqual(address.city, "NY")
        XCTAssertEqual(address.state, "NY")
        XCTAssertEqual(address.country, "USA")
    }

    func testCreateOrUpdateUpdatesExistingAddress() throws {
        let id = UUID()

        // Primero crear
        let dto1 = AddressDTO(id: id,
                              street: "Old Street",
                              city: "Old City",
                              state: "Old State",
                              country: "Old Country")

        _ = Address.createOrUpdate(from: dto1, in: ctx)
        try ctx.save()

        // Luego actualizar
        let dto2 = AddressDTO(id: id,
                              street: "New Street",
                              city: "New City",
                              state: "New State",
                              country: "New Country")

        let updated = Address.createOrUpdate(from: dto2, in: ctx)
        try ctx.save()

        XCTAssertEqual(updated.id, id)
        XCTAssertEqual(updated.street, "New Street")
        XCTAssertEqual(updated.city, "New City")
        XCTAssertEqual(updated.state, "New State")
        XCTAssertEqual(updated.country, "New Country")
    }
}

