//
//  AddressDetailViewModelTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import XCTest
import CoreData
@testable import Address

final class AddressDetailViewModelTests: XCTestCase {

    var ctx: NSManagedObjectContext!
    var parent: AddressListViewModel!

    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "MyAddressAppModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, err in XCTAssertNil(err) }
        ctx = container.viewContext
        parent = AddressListViewModel(context: ctx)
    }

    func testSaveCreatesAddress() {
        let vm = AddressDetailViewModel(address: nil, context: ctx, parentListViewModel: parent)
        vm.street = "Created"
        vm.city = "City"
        vm.state = "State"
        vm.country = "Country"

        vm.save()

        XCTAssertEqual(parent.addresses.count, 1)
        XCTAssertEqual(parent.addresses.first?.street, "Created")
    }

    func testSaveUpdatesAddress() {
        let addr = Address(context: ctx)
        addr.id = UUID()
        addr.street = "Old"

        try? ctx.save()

        let vm = AddressDetailViewModel(address: addr, context: ctx, parentListViewModel: parent)
        vm.street = "Updated"
        vm.save()

        XCTAssertEqual(parent.addresses.first?.street, "Updated")
    }
}
