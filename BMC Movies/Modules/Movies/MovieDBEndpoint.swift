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
  case search(query: String, page: Int)
  case discover(genreId: Int, sortBy: SortOption, page: Int)
  case credits(movieId: Int)
}

extension MovieDBEndpoint: MovieDBAPIEndpoint {
  var method: String { "GET" }
  
  var path: String {
    switch self {
    case .nowPlaying: "movie/now_playing"
    case .popular: "movie/popular"
    case .topRated: "movie/top_rated"
    case .search: "search/movie"
    case .discover: "discover/movie"
    case .credits(let movieId): "movie/\(movieId)/credits"
    }
  }
  
  var queryItems: [URLQueryItem]? {
    switch self {
    case .nowPlaying, .popular, .topRated:
      [URLQueryItem(name: "language", value: "en-US")]
    case .search(let query, let page):
      [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "page", value: "\(page)")
      ]
    case .discover(let genreId, let sortBy, let page):
      [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "with_genres", value: "\(genreId)"),
        URLQueryItem(name: "sort_by", value: sortBy.rawValue),
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "include_adult", value: "false"),
        URLQueryItem(name: "include_video", value: "false")
        
      ]
    case .credits:
      [URLQueryItem(name: "language", value: "en-US")]
    }
  }
}
