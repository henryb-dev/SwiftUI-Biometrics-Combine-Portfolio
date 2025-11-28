//
//  AddressDetailViewModel.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI
import CoreData
import Combine

class AddressDetailViewModel: ObservableObject {
    @Published var street = ""
    @Published var city = ""
    @Published var state = ""
    @Published var country = ""
    private var address: Address?
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    @Published var parentListViewModel: AddressListViewModel

    init(
        address: Address?,
        context: NSManagedObjectContext,
        parentListViewModel: AddressListViewModel
    ) {
        self.address = address
        self.context = context
        self.parentListViewModel = parentListViewModel
        if let a = address {
            street = a.street ?? ""
            city = a.city ?? ""
            state = a.state ?? ""
            country = a.country ?? ""
        }
    }

    func save() {
        let entity = address ?? Address(context: context)
        entity.id = address?.id ?? UUID()
        entity.street = street
        entity.city = city
        entity.state = state
        entity.country = country
        do {
            try context.save()
            parentListViewModel.fetchLocal()
        } catch {
            print("Error saving address: \(error)")
        }
    }
}
