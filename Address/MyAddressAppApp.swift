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
