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
    @Published var addresses: [Address] = []
    private var cancellables = Set<AnyCancellable>()
    let viewContext: NSManagedObjectContext
    let api: APIServiceProtocol
    var isTestMode = false

    init(context: NSManagedObjectContext, api: APIServiceProtocol = APIService.shared) {
        self.viewContext = context
        self.api = api
        load()
    }
    
    func load() {
        fetchLocal()
        fetchRemote()
    }

    func fetchLocal() {
        let request: NSFetchRequest<Address> = Address.fetchRequest()
        addresses = (try? viewContext.fetch(request)) ?? []
    }

    func fetchRemote() {
        api.fetchAddresses()
            .receive(on: DispatchQueue.main)
            .delay(for: .milliseconds(10), scheduler: DispatchQueue.main) 
            .sink(receiveCompletion: { _ in },
                  receiveValue: { dtos in
                    for dto in dtos {
                        _ = Address.createOrUpdate(from: dto, in: self.viewContext)
                    }
                    try? self.viewContext.save()
                    self.fetchLocal()
                  })
            .store(in: &cancellables)
    }
}
