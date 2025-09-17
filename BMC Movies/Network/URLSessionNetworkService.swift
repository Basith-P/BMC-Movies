//
//  URLSessionNetworkService.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Combine
import Foundation

struct URLSessionNetworkService: NetworkService {
  func request<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError> {
    do {
      let urlRequest = try endpoint.asURLRequest()
      return URLSession.shared.dataTaskPublisher(for: urlRequest)
        .tryMap { data, response -> Data in
          guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
          }
          guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
          }
          return data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError { error -> NetworkError in
          if let networkError = error as? NetworkError {
            return networkError
          } else {
            return .decodingFailed(error)
          }
        }
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: (error as? NetworkError) ?? .invalidURL)
        .eraseToAnyPublisher()
    }
  }
}
