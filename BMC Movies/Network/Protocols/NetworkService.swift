//
//  NetworkService.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation
import Combine

protocol NetworkService {
  func request<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError>
}
