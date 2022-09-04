//
//  PersistentContainerFactory.swift
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 9/3/22.
//

import Foundation
import CoreData

enum StorageType {
    case inMemory, persistent
}

class PersistentContainerFactory {
    static func create(of storage: StorageType) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Data")
        if storage == .inMemory {
            let desc = NSPersistentStoreDescription()
            desc.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [desc]
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
}
