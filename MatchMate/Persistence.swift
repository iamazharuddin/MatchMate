//
//  Persistence.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//


import CoreData
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MatchMate")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Optional: Add a function to save changes if needed
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func printDocumentDirecrotyPath(){
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}
