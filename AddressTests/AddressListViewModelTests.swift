//
//  AddressListViewModelTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import XCTest
import CoreData
import Combine
@testable import Address

final class AddressListViewModelTests: XCTestCase {

    var ctx: NSManagedObjectContext!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "MyAddressAppModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, err in XCTAssertNil(err) }
        ctx = container.viewContext
    }

    func testFetchLocalLoadsAddresses() throws {
        let a = Address(context: ctx)
        a.id = UUID()
        a.street = "Test Street"
        try ctx.save()

        let vm = AddressListViewModel(context: ctx)
        vm.load()
        XCTAssertEqual(vm.addresses.count, 1)
        XCTAssertEqual(vm.addresses.first?.street, "Test Street")
    }

    func testFetchRemoteLoadsDTOs() {
        let mockService = MockAPIService()
        let dto1 = AddressDTO(id: UUID(),
                             street: "Main St",
                             city: "NY",
                             state: "NY",
                             country: "USA")
        mockService.addressesToReturn = [
            dto1
        ]
        let vm = AddressListViewModel(context: ctx, api: mockService as APIServiceProtocol)
        let expectation = self.expectation(description: "addresses updated")
        
        var cancellable: AnyCancellable?
        cancellable = vm.$addresses
            .dropFirst()
            .sink { addresses in
                XCTAssertEqual(addresses.count, 1)
                    expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
        cancellable?.cancel()
    }
}
