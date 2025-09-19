//
//  AccessibilyId.swift
//  BMC Movies
//
//  Created by Basith Lascade on 19/09/25.
//

import Foundation

struct AccessibilyId {
  static let nowPlaying = "nowPlaying"
  static let popular = "popular"
  static let topRated = "topRated"
  static let favoritesButton = "favoritesButton"

  static func movieCard(sectionId: String, movieId: Int) -> String { "\(sectionId)_movieCard_\(movieId)" }
  static func favoriteMovieCard(movieId: Int) -> String { "favoriteMovieCard_\(movieId)" }
}
