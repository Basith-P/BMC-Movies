//
//  Logger+Extension.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import OSLog

extension Logger {
  private static var subsystem = Bundle.main.bundleIdentifier!

  static let general = Logger(subsystem: subsystem, category: "General")
  static let coreData = Logger(subsystem: subsystem, category: "CoreData")
  static let favorites = Logger(subsystem: subsystem, category: "Favorites")
}
