//
//  MovieDBAPIEndpoint.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation

protocol MovieDBAPIEndpoint: APIEndpoint {}

extension MovieDBAPIEndpoint {
  var baseURL: URL {
    guard let url = URL(string: "https://api.themoviedb.org/3/") else {
      fatalError("Base URL is invalid")
    }

    return url
  }

  var headers: [String : String]? {
    return [
      "accept": "application/json",
      "Authorization": "Bearer \(AppConfig.tmdbAccessToken)"
    ]
  }
}
