//
//  APIService.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import Foundation
import Combine

struct AddressDTO: Codable {
    let id: UUID
    let street: String
    let city: String
    let state: String
    let country: String
}

class APIService {
    static let shared = APIService()
    private init() {}

    func fetchAddresses() -> AnyPublisher<[AddressDTO], Error> {
        let url = URL(string: "https://api.public-service.com/addresses")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AddressDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
