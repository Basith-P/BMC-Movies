//
//  MovieDBEndpoint.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation

enum MovieDBEndpoint {
  enum TimelineWindow {
    case day, week
  }

  case nowPlaying
  case popular
  case topRated
}

extension MovieDBEndpoint: MovieDBAPIEndpoint {
  var method: String { "GET" }

  var path: String {
    switch self {
    case .nowPlaying: "movie/now_playing"
    case .popular: "movie/popular"
    case .topRated: "movie/top_rated"
    }
  }

  var queryItems: [URLQueryItem]? {
    switch self {
    case .nowPlaying, .popular, .topRated:
      [URLQueryItem(name: "language", value: "en-US")]
    }
  }
}
