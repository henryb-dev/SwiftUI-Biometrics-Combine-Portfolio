//
//  APIServiceTests.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//


import XCTest
import Combine
import CoreData
@testable import Address

final class APIServiceTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    var ctx: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        // Creamos un contexto en memoria para CoreData
        ctx = PersistenceController(inMemory: true).container.viewContext
        cancellables.removeAll()
    }

    func testFetchAddressesSuccess() {
        // Creamos mock con datos
        let mockService = MockAPIService()
        mockService.addressesToReturn = [
            AddressDTO(id: UUID(), street: "Calle 1", city: "Ciudad", state: "Estado", country: "País")
        ]

        // Inyectamos mock en el ViewModel
        let vm = AddressListViewModel(context: ctx, api: mockService)
        vm.load()

        // Llamamos fetchRemote y esperamos que guarde en CoreData
        let expectation = self.expectation(description: "fetch addresses")
        
        var cancellable: AnyCancellable?
        cancellable = vm.$addresses
            .dropFirst() // ignora el array vacío inicial
            .first()
            .sink { addresses in
                if addresses.count == 1 {
                    expectation.fulfill()
                }
            }

   //     vm.fetchRemote()  // método del ViewModel

        wait(for: [expectation], timeout: 2)
        cancellable?.cancel()
    }

    func testFetchAddressesFailure() {
        let mockService = MockAPIService()
        mockService.shouldFail = true

        let expectation = self.expectation(description: "fetch failure")

        mockService.fetchAddresses()
            .dropFirst()
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        expectation.fulfill()
                    case .finished:
                        XCTFail("Should have failed")
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail("Should not receive value")
                })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }
}
