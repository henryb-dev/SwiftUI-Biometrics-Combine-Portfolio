//
//  AddressListViewModel.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI
import CoreData
import Combine

class AddressListViewModel: ObservableObject {
    @Published var addresses = [Address]()
    private var cancellables = Set<AnyCancellable>()
    let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        viewContext = context
        fetchLocal()
        fetchRemote()
    }

    func fetchLocal() {
        let request: NSFetchRequest<Address> = Address.fetchRequest()
        if let result = try? viewContext.fetch(request) {
            addresses = result
        }
    }

    func fetchRemote() {
        APIService.shared.fetchAddresses()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }, receiveValue: { dtos in
                for dto in dtos {
                    _ = Address.createOrUpdate(from: dto, in: self.viewContext)
                }
                try? self.viewContext.save()
                self.fetchLocal()
            })
            .store(in: &cancellables)
    }
}
