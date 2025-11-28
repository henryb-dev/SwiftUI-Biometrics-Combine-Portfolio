//
//  AddressListView.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI

struct AddressListView: View {
    @ObservedObject var viewModel: AddressListViewModel
    @State private var showAdd = false
    @State var searchText = ""

    var body: some View {
        List {
            ForEach(filteredItems, id: \.id) { addr in
                NavigationLink(destination: AddressDetailView(
                    viewModel: AddressDetailViewModel(
                        address: addr,
                        context: viewModel.viewContext,
                        parentListViewModel: viewModel))) {
                    VStack(alignment: .leading) {
                        Text(addr.street ?? "")
                        Text("\(addr.city ?? ""), \(addr.state ?? ""), \(addr.country ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onMove(perform: move)
            .onDelete { idx in
                let toDel = viewModel.addresses[idx.first!]
                viewModel.viewContext.delete(toDel)
                try? viewModel.viewContext.save()
                viewModel.fetchLocal()
            }
            
        }
        .navigationTitle("Direcciones")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAdd = true }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showAdd) {
                    AddressDetailView(viewModel: AddressDetailViewModel(address: nil, context: viewModel.viewContext, parentListViewModel: viewModel))
                }
            }
        }
        .searchable(text: $searchText, prompt: "buscar")
        
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        viewModel.addresses.move(fromOffsets: source, toOffset: destination)
    }
    
    var filteredItems: [Address] {
        if searchText.isEmpty {
            return viewModel.addresses
        } else {
            return viewModel.addresses.filter { address in
                address.city?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
}
