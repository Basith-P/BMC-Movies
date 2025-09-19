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
    let movieResponse = MovieResponse(results: Movie.sampleList)

    guard let data = movieResponse as? T else {
      return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }

    return Just(data)
      .setFailureType(to: NetworkError.self)
      .eraseToAnyPublisher()
  }
}

#endif // DEBUG
