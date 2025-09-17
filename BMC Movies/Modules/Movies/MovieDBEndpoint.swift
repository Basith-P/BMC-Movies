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
  case search(query: String)
}

extension MovieDBEndpoint: MovieDBAPIEndpoint {
  var method: String { "GET" }

  var path: String {
    switch self {
    case .nowPlaying: "movie/now_playing"
    case .popular: "movie/popular"
    case .topRated: "movie/top_rated"
    case .search: "search/movie"
    }
  }

  var queryItems: [URLQueryItem]? {
    switch self {
    case .nowPlaying, .popular, .topRated:
      [URLQueryItem(name: "language", value: "en-US")]
    case .search(let query):
      [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "query", value: query)
      ]
    }
  }
}
