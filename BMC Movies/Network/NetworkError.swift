//
//  NetworkError.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
  case invalidURL
  case requestFailed(Error)
  case decodingFailed(Error)
  case invalidResponse
  case httpError(statusCode: Int)

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      "The URL provided was invalid."
    case .requestFailed(let error):
      "The network request failed: \(error.localizedDescription)"
    case .decodingFailed(let error):
      "Failed to decode the response: \(error.localizedDescription)"
    case .invalidResponse:
      "Received an invalid response from the server."
    case .httpError(let statusCode):
      "Request failed with status code: \(statusCode)"
    }
  }
}
