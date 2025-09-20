//
//  MovieDetailsViewModel.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import Combine
import Foundation
import OSLog

final class MovieDetailsViewModel: ObservableObject {
  @Published var creditsState: LoadableState<CreditsResponse> = .idle

  private let networkService: NetworkService
  private var cancellables = Set<AnyCancellable>()

  init(networkService: NetworkService = URLSessionNetworkService()) {
    self.networkService = networkService
  }

  func fetchCredits(movieId: Int) {
    creditsState = .loading

    networkService.request(endpoint: MovieDBEndpoint.credits(movieId: movieId))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.creditsState = .failed(error)
          Logger.general.error("failed to load credits for movie id: \(movieId): \(error)")
        case .finished:
          break
        }
      } receiveValue: { [weak self] (response: CreditsResponse) in
        self?.creditsState = .loaded(response)
      }
      .store(in: &cancellables)
  }
}
