//
//  CoreDataManager.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import CoreData
import OSLog

class CoreDataManager {
  static let shared = CoreDataManager()

  let container = NSPersistentContainer(name: "BMCMovies")

  private init() {
    container.loadPersistentStores { _, error in
      if let error {
        Logger.coreData.error("CoreData Failed to Load: \(error.localizedDescription)")
      }
    }
  }

  var context: NSManagedObjectContext { container.viewContext }

  func save() {
    if context.hasChanges {
      try? context.save()
    }
  }
}
