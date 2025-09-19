//
//  GenreCache.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Foundation
import Combine

class GenreCache: ObservableObject, GenreProvider {
  static let shared = GenreCache()

  private let genresKey = "cached_movie_genres"
  private let lastFetchKey = "last_genre_fetch_date"
  private let cacheDuration: TimeInterval = 7 * 24 * 60 * 60 // 1 week

  private var cancellable: AnyCancellable?

  @Published private(set) var genres: [Genre] = []

  private init() {
    loadFromCache()
    fetchGenresIfNeeded()
  }

  private func loadFromCache() {
    guard let data = UserDefaults.standard.data(forKey: genresKey) else { return }
    if let decodedGenres = try? JSONDecoder().decode([Genre].self, from: data) {
      self.genres = decodedGenres
    }
  }

  private func fetchGenresIfNeeded() {
    if let lastFetchDate = UserDefaults.standard.object(forKey: lastFetchKey) as? Date {
      if Date().timeIntervalSince(lastFetchDate) < cacheDuration {
        return
      }
    }

    guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = [
      "accept": "application/json",
      "Authorization": "Bearer \(AppConfig.tmdbAccessToken)"
    ]

    cancellable = URLSession.shared.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: GenreResponse.self, decoder: JSONDecoder())
      .map(\.genres)
      .replaceError(with: [])
      .receive(on: DispatchQueue.main)
      .sink { [weak self] fetchedGenres in
        self?.genres = fetchedGenres
        self?.saveToCache(genres: fetchedGenres)
      }
  }

  private func saveToCache(genres: [Genre]) {
    if let encodedData = try? JSONEncoder().encode(genres) {
      UserDefaults.standard.set(encodedData, forKey: genresKey)
      UserDefaults.standard.set(Date(), forKey: lastFetchKey)
    }
  }

  func genreName(for id: Int) -> String? {
    return genres.first { $0.id == id }?.name
  }
}
