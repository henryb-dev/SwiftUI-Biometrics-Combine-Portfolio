//
//  MyAddressAppApp.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import SwiftUI

@main
struct MyAddressApp: App {
    static let persistence = PersistenceController.shared
    
    @StateObject var authVM = AuthViewModel()
    @StateObject var pushMgr = PushNotificationManager()
    @StateObject var listVM = AddressListViewModel(context: persistence.container.viewContext)

    
    init() {
        // Detectar argumentos enviados desde UI Tests
        let args = ProcessInfo.processInfo.arguments
        let ctx = PersistenceController.shared.container.viewContext
        
        if args.contains("-uiTest_loginView") {
            print("UI TEST: Launching LoginView in test mode")
            
            // Aquí puedes activar cosas especiales para testing:
            // authVM.isTestMode = true
            // authVM.shouldBypassBiometrics = true
        }
        if args.contains("-uiTest_biometricSuccess") {
            print("UI TEST: Simulando biometría exitosa")
            authVM.isUITestBiometricSuccess = true
        }
        if args.contains("-uiTest_addressList") {
            print("UI TEST: Loading mock address list")

            var dto = AddressDTO(id: UUID(),
                                 street: "Main St",
                                 city: "NY",
                                 state: "NY",
                                 country: "USA")
            let addressOne = Address.createOrUpdate(from: dto, in: ctx)
            dto = AddressDTO(id: UUID(),
                                 street: "Calle",
                                 city: "Madrid",
                                 state: "Cundinamarca",
                                 country: "Colombia")
            let addressTwo = Address.createOrUpdate(from: dto, in: ctx)
            let mockAddresses = [addressOne, addressTwo]

            listVM.isTestMode = true
            listVM.addresses = mockAddresses
        }

    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isAuthenticated {
                    ContentView()
                        .environment(\.managedObjectContext, Self.persistence.container.viewContext)
                        .environmentObject(authVM)
                        .environmentObject(listVM)
                } else {
                    LoginView()
                        .environmentObject(authVM)
                }
            }
            .onAppear {
                pushMgr.registerForPush()
            }
        }
    }
}
