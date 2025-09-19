//
//  MoviesViewModel.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Combine
import OSLog
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
    fetchMovies(for: \MoviesViewModel.nowPlayingState, for: .nowPlaying)
  }

  func fetchPopular() {
    fetchMovies(for: \MoviesViewModel.popularState, for: .popular)
  }

  func fetchTopRated() {
    fetchMovies(for: \MoviesViewModel.topRatedState, for: .topRated)
  }

  func searchMovie(query: String) {
    guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return
    }

    fetchMovies(for: \MoviesViewModel.searchResults, for: .search(query: query))
  }

  // MARK: - Private Methods

  private func fetchMovies(
    for stateKeyPath: ReferenceWritableKeyPath<MoviesViewModel, LoadableState<[Movie]>>,
    for endpoint: MovieDBEndpoint
  ) {
    self[keyPath: stateKeyPath] = .loading

    networkService.request(endpoint: endpoint)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] sinkCompletion in
        switch sinkCompletion {
        case .failure(let error):
          self?[keyPath: stateKeyPath] = .failed(error)
          Logger.general.error("failed to load movies for \(String(describing: stateKeyPath)): \(error)")
        case .finished:
          break
        }
      } receiveValue: { [weak self] (response: MovieResponse) in
        self?[keyPath: stateKeyPath] = .loaded(response.results)
      }
      .store(in: &cancellables)
  }
}

