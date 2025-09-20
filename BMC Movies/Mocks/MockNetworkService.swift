//
//  MockNetworkService.swift
//  BMC_MoviesUITests
//
//  Created by Basith Lascade on 19/09/25.
//

#if DEBUG
import Combine
import Foundation

struct MockNetworkService: NetworkService {
  func request<T>(endpoint: any APIEndpoint) -> AnyPublisher<T, NetworkError> where T : Decodable {
    let movieResponse = MovieResponse(
      page: 1,
      results: Movie.sampleList,
      totalPages: 3,
      totalResults: Movie.sampleList.count * 3
    )

    guard let data = movieResponse as? T else {
      return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }

    return Just(data)
      .setFailureType(to: NetworkError.self)
      .eraseToAnyPublisher()
  }
}

#endif // DEBUG
