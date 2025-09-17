//
//  APIEndpoint.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation

protocol APIEndpoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: String { get }
  var headers: [String: String]? { get }
  var queryItems: [URLQueryItem]? { get }
}

extension APIEndpoint {
  func asURLRequest() throws -> URLRequest {
    guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
      throw NetworkError.invalidURL
    }

    components.queryItems = queryItems

    guard let url = components.url else {
      throw NetworkError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    return request
  }
}
