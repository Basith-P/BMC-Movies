//
//  MoviesViewModel.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Combine
import SwiftUI

class MoviesViewModel: ObservableObject {
  @Published var nowPlayingState: LoadableState<[Movie]> = .idle
  @Published var popularState: LoadableState<[Movie]> = .idle
  @Published var topRatedState: LoadableState<[Movie]> = .idle
  @Published var searchResults: LoadableState<[Movie]> = .idle

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
      self?.nowPlayingState = .loaded(movies)
    }
  }

  func fetchPopular() {
    fetchMovies(of: .popular) { [weak self] movies in
      self?.popularState = .loaded(movies)
    }
  }

  func fetchTopRated() {
    fetchMovies(of: .topRated) { [weak self] movies in
      self?.topRatedState = .loaded(movies)
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
