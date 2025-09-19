//
//  FavoritesManager.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Combine
import CoreData
import Foundation
import OSLog

class FavoritesManager: ObservableObject {
  static let shared = FavoritesManager()
  
  @Published private(set) var favoriteMovies: [Movie] = []
  @Published private(set) var isLoading: Bool = false

  private let coreData = CoreDataManager.shared
  private let logger = Logger.favorites

  private init() {
    loadFavorites()
  }
  
  // MARK: - Public Methods
  
  func isFavorite(_ movie: Movie) -> Bool {
    favoriteMovies.contains { $0.id == movie.id }
  }
  
  func toggleFavorite(_ movie: Movie) {
    if isFavorite(movie) {
      removeFavorite(movie)
    } else {
      addFavorite(movie)
    }
  }
  
  func addFavorite(_ movie: Movie) {
    guard !isFavorite(movie) else { return }
    
    favoriteMovies.append(movie)
    persistAddition(movie)
  }
  
  func removeFavorite(_ movie: Movie) {
    favoriteMovies.removeAll { $0.id == movie.id }
    persistRemoval(movie)
  }
  
  // MARK: - Private Methods
  
  private func loadFavorites() {
    isLoading = true

    let context = coreData.container.newBackgroundContext()

    context.perform { [weak self] in
      guard let self else { return }

      let fetchRequest = FavoriteMovie.fetchRequest()
      fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMovie.title, ascending: true)]

      do {
        let favoriteMovies = try context.fetch(fetchRequest)
        let movies = favoriteMovies.compactMap { Movie.from($0) }

        DispatchQueue.main.async {
          self.favoriteMovies = movies
          self.isLoading = false
        }
      } catch {
        DispatchQueue.main.async { self.isLoading = false }
        logger.error("Failed to load favorite movies: \(error.localizedDescription)")
      }
    }
  }

  private func persistAddition(_ movie: Movie) {
    let isUITest = ProcessInfo.processInfo.arguments.contains("UI_TESTS")
    guard !isUITest else { return }

    let context = coreData.container.newBackgroundContext()

    context.perform { [weak self] in
      guard let self else { return }

      let fetchRequest = FavoriteMovie.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

      do {
        let existingCount = try context.count(for: fetchRequest)
        guard existingCount == 0 else { return }

        let favoriteMovie = FavoriteMovie(context: context)
        self.mapMovieToEntity(movie, entity: favoriteMovie)

        try context.save()
      } catch {
        logger.error("Failed to add favorite movie: \(error.localizedDescription)")

        DispatchQueue.main.async {
          self.favoriteMovies.removeAll { $0.id == movie.id }
        }
      }
    }
  }

  private func persistRemoval(_ movie: Movie) {
    let isUITest = ProcessInfo.processInfo.arguments.contains("UI_TESTS")
    guard !isUITest else { return }
    
    let context = coreData.container.newBackgroundContext()

    context.perform { [weak self] in
      guard let self else { return }

      let fetchRequest = FavoriteMovie.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

      do {
        let favorites = try context.fetch(fetchRequest)
        favorites.forEach { context.delete($0) }

        try context.save()
      } catch {
        logger.error("Failed to remove favorite movie: \(error.localizedDescription)")

        DispatchQueue.main.async {
          self.favoriteMovies.append(movie)
        }
      }
    }
  }

  private func mapMovieToEntity(_ movie: Movie, entity: FavoriteMovie) {
    entity.id = Int32(movie.id)
    entity.title = movie.title
    entity.originalTitle = movie.originalTitle
    entity.overview = movie.overview
    entity.posterPath = movie.posterPath
    entity.backdropPath = movie.backdropPath
    entity.originalLanguage = movie.originalLanguage
    entity.genreIds = movie.genreIds as NSArray
    entity.popularity = movie.popularity
    entity.releaseDate = movie.releaseDate
    entity.adult = movie.adult
    entity.voteAverage = movie.voteAverage
    entity.voteCount = Int32(movie.voteCount)
  }
}
