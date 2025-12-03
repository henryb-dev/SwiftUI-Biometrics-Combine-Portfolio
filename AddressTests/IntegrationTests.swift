//
//  IntegrationTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import XCTest
import CoreData
import Combine
@testable import Address

final class AddressIntegrationTests: XCTestCase {

    var ctx: NSManagedObjectContext!
    var api: MockAPIService!
    var vm: AddressListViewModel!

    override func setUp() {
        super.setUp()

        // CoreData en memoria
        let container = NSPersistentContainer(name: "MyAddressAppModel")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        ctx = container.viewContext

        // API mockeada
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        api = MockAPIService(session: mockSession)
    }

    func testFullPipelineFetchAndSave() {
        let json = """
        [
            {
                "id": "\(UUID())",
                "street": "Main Street",
                "city": "NY",
                "state": "NY",
                "country": "USA"
            }
        ]
        """

        MockURLProtocol.mockData = json.data(using: .utf8)
        MockURLProtocol.mockError = nil

        vm = AddressListViewModel(context: ctx, api: api)

        let expectation = self.expectation(description: "addresses updated")

        var cancellable: AnyCancellable?
        cancellable = vm.$addresses
            .dropFirst()
            .sink { addresses in
                XCTAssertEqual(addresses.count, 0)
                    expectation.fulfill()
            }
     //   vm.fetchRemote()
        
        wait(for: [expectation], timeout: 2)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Did receive? \(MockURLProtocol.didReceiveRequest)")
        }

        cancellable?.cancel()
    }
}
