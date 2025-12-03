//
//  MockAPIService.swift
//  Address
//
//  Created by Henry Bautista on 1/12/25.
//

import Foundation
import Combine
@testable import Address

class MockAPIService: APIServiceProtocol {
    let session: URLSession

    init(session: URLSession = .shared) { self.session = session }

    // Test-controlled inputs
    var addressesToReturn: [AddressDTO] = []
    var shouldFail: Bool = false
    var errorToReturn: Error = NSError(domain: "MockAPIService", code: -1)

    func fetchAddresses() -> AnyPublisher<[AddressDTO], Error> {
        if shouldFail {
            return Fail(error: errorToReturn)
                .eraseToAnyPublisher()
        } else {
            return Just(addressesToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
