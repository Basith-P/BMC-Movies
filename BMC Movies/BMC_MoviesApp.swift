//
//  BMC_MoviesApp.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import CoreData
import SwiftUI

@main
struct BMC_MoviesApp: App {

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, CoreDataManager.shared.context)
    }
  }
}
