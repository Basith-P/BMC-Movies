//
//  MoviesViewModel.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Combine
import SwiftUI

class MoviesViewModel: ObservableObject {
  @Published var nowPlayingMovies: [Movie] = []
  @Published var popularMovies: [Movie] = []
  @Published var topRatedMovies: [Movie] = []
  @Published var searchResults: [Movie] = []

  @Published var isLoading: Bool = false
  @Published var error: NetworkError? = nil

  private let networkService: NetworkService
  private var cancellables = Set<AnyCancellable>()

  init(networkService: NetworkService = URLSessionNetworkService()) {
    self.networkService = networkService

    fetchNowPlaying()
    fetchPopular()
    fetchTopRated()
  }

  func fetchNowPlaying() {
    fetchMovies(of: .nowPlaying) { [weak self] movies in
      self?.nowPlayingMovies = movies
      print("Now Playing Movies: \(movies.count)")
    }
  }

  func fetchPopular() {
    fetchMovies(of: .popular) { [weak self] movies in
      self?.popularMovies = movies
      print("Popular Movies: \(movies.count)")
    }
  }

  func fetchTopRated() {
    fetchMovies(of: .topRated) { [weak self] movies in
      self?.topRatedMovies = movies
      print("Top Rated Movies: \(movies.count)")
    }
  }

  func searchMovie(query: String) {
    // https://api.themoviedb.org/3/search/movie
    // query string required
  }

  // MARK: - Private Methods

  private func fetchMovies(of endpoint: MovieDBEndpoint, completion: @escaping ([Movie]) -> Void) {
    networkService.request(endpoint: endpoint)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] sinkCompletion in
        
      } receiveValue: { (response: MovieResponse) in
        completion(response.results)
      }
      .store(in: &cancellables)
  }
}
