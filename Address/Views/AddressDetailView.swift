//
//  AddressDetailView.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI

struct AddressDetailView: View {
    @Environment(\.presentationMode) var pm
    @ObservedObject var viewModel: AddressDetailViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dirección")) { TextField("Direccion", text: $viewModel.street) }
                Section(header: Text("Ciudad")) { TextField("Ciudad", text: $viewModel.city) }
                Section(header: Text("Departamento")) { TextField("Departamento", text: $viewModel.state) }
                Section(header: Text("País")) { TextField("País", text: $viewModel.country) }
            }
            .navigationTitle("Detalles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        viewModel.save()
                        pm.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

/*#Preview {
    AddressDetailView(viewModel: AddressDetailViewModel(address: <#Address?#>, context: NSManagedObjectContext?))
}*/
