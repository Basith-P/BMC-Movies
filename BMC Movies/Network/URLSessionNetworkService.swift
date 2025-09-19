//
//  URLSessionNetworkService.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Combine
import Foundation

struct URLSessionNetworkService: NetworkService {
  private let session: URLSession
  private let decoder: JSONDecoder

  init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
    self.session = session
    self.decoder = decoder
  }

  func request<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError> {
    do {
      let urlRequest = try endpoint.asURLRequest()
      return session.dataTaskPublisher(for: urlRequest)
        .tryMap { data, response -> Data in
          guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
          }
          guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
          }
          return data
        }
        .decode(type: T.self, decoder: decoder)
        .mapError { error -> NetworkError in
          if let urlError = error as? URLError {
            return .requestFailed(urlError)
          } else if let decodingError = error as? DecodingError {
            return .decodingFailed(decodingError)
          } else if let networkError = error as? NetworkError {
            return networkError
          } else {
            return .requestFailed(error)
          }
        }
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: (error as? NetworkError) ?? .invalidURL)
        .eraseToAnyPublisher()
    }
  }
}
