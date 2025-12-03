//
//  APIService.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import Foundation
import Combine



protocol APIServiceProtocol {
    func fetchAddresses() -> AnyPublisher<[AddressDTO], Error>
}

class APIService {
    static let shared = APIService()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAddresses() -> AnyPublisher<[AddressDTO], Error> {
        let url = URL(string: "https://api.public-service.com/addresses")!
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AddressDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension APIService: APIServiceProtocol {}
