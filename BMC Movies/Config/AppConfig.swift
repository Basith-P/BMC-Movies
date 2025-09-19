//
//  AppConfig.swift
//  BMC Movies
//
//  Created by Basith Lascade on 19/09/25.
//

import Foundation

struct AppConfig {
  static var tmdbAccessToken: String {
    guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String,
          !token.isEmpty else {
      assertionFailure("TMDBAccessToken is missing. Did you configure Debug.xcconfig and Base Configuration?")
      return ""
    }
    return token
  }
}
