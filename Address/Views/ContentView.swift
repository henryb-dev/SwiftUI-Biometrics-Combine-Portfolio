//
//  ContentView.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var vm: AddressListViewModel

    init() {
        _vm = StateObject(wrappedValue: AddressListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationView {
            AddressListView(viewModel: vm)
        }
    }
}
