//
//  Persistence.swift
//  Address
//
//  Created by Henry Bautista on 22/07/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyAddressAppModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
