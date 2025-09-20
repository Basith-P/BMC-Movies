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
  @Published var moviesByGenre: LoadableState<[Movie]> = .idle
  // Pagination - Genre
  @Published var isLoadingMoreGenre: Bool = false
  private var currentGenreId: Int?
  private var currentGenreSort: SortOption = .popularityDesc
  private var currentGenrePage: Int = 1
  private var totalGenrePages: Int = 1
  // Pagination - Search
  @Published var isLoadingMoreSearch: Bool = false
  private var currentSearchQuery: String = ""
  private var currentSearchPage: Int = 1
  private var totalSearchPages: Int = 1
  
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
    fetchMovies(for: \.nowPlayingState, for: .nowPlaying)
  }
  
  func fetchPopular() {
    fetchMovies(for: \.popularState, for: .popular)
  }
  
  func fetchTopRated() {
    fetchMovies(for: \.topRatedState, for: .topRated)
  }
  
  func searchMovie(query: String) {
    guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return
    }
    currentSearchQuery = query
    currentSearchPage = 1
    totalSearchPages = 1
    searchResults = .loading

    networkService.request(endpoint: MovieDBEndpoint.search(query: query, page: 1))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.searchResults = .failed(error)
          Logger.general.error("failed to load search results for query \(query): \(error)")
        case .finished:
          break
        }
      } receiveValue: { [weak self] (response: MovieResponse) in
        self?.searchResults = .loaded(response.results)
        self?.currentSearchPage = response.page
        self?.totalSearchPages = response.totalPages
      }
      .store(in: &cancellables)
  }

  func loadMoreSearchResults() {
    guard !isLoadingMoreSearch,
          case .loaded(let currentMovies) = searchResults,
          !currentSearchQuery.isEmpty,
          currentSearchPage < totalSearchPages else { return }

    isLoadingMoreSearch = true

    networkService.request(endpoint: MovieDBEndpoint.search(query: currentSearchQuery, page: currentSearchPage + 1))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          Logger.general.error("failed to load more search results for query \(self?.currentSearchQuery ?? ""): \(error)")
          self?.isLoadingMoreSearch = false
        }
      } receiveValue: { [weak self] (response: MovieResponse) in
        guard let self else { return }
        var combined = currentMovies
        let existingIds = Set(currentMovies.map { $0.id })
        let newOnes = response.results.filter { !existingIds.contains($0.id) }
        combined.append(contentsOf: newOnes)
        self.searchResults = .loaded(combined)
        self.currentSearchPage = response.page
        self.isLoadingMoreSearch = false
        self.totalSearchPages = response.totalPages
      }
      .store(in: &cancellables)
  }
  
  func fetchMoviesByGenre(genreId: Int, sortBy: SortOption = .popularityDesc) {
    currentGenreId = genreId
    currentGenreSort = sortBy
    currentGenrePage = 1
    totalGenrePages = 1
    moviesByGenre = .loading

    networkService.request(endpoint: MovieDBEndpoint.discover(genreId: genreId, sortBy: sortBy, page: 1))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.moviesByGenre = .failed(error)
          Logger.general.error("failed to load movies for genre \(genreId): \(error)")
        case .finished:
          break
        }
      } receiveValue: { [weak self] (response: MovieResponse) in
        self?.moviesByGenre = .loaded(response.results)
        self?.currentGenrePage = response.page
        self?.totalGenrePages = response.totalPages
      }
      .store(in: &cancellables)
  }

  func loadMoreMoviesByGenre() {
    guard !isLoadingMoreGenre,
          case .loaded(let currentMovies) = moviesByGenre,
          let genreId = currentGenreId,
          currentGenrePage < totalGenrePages else { return }

    isLoadingMoreGenre = true

    networkService.request(endpoint: MovieDBEndpoint.discover(genreId: genreId, sortBy: currentGenreSort, page: currentGenrePage + 1))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          Logger.general.error("failed to load more movies for genre \(genreId): \(error)")
          self?.isLoadingMoreGenre = false
        }
      } receiveValue: { [weak self] (response: MovieResponse) in
        guard let self else { return }
        var combined = currentMovies
        let existingIds = Set(currentMovies.map { $0.id })
        let newOnes = response.results.filter { !existingIds.contains($0.id) }
        combined.append(contentsOf: newOnes)
        self.moviesByGenre = .loaded(combined)
        self.currentGenrePage = response.page
        self.isLoadingMoreGenre = false
        self.totalGenrePages = response.totalPages
      }
      .store(in: &cancellables)
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
