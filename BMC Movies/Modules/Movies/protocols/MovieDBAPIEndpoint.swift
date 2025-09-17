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
    let apiAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNjM2ZTNkYzRmNzcxZmRiZDFlMDMxZjU0NWRhYmE2OCIsIm5iZiI6MTc1ODEwNjUyOC4zMDQsInN1YiI6IjY4Y2E5M2EwM2NmYjc3ZjU0ZGU0ZmIzNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.A5ZNbRRoWThfQwwZu6j2JLHeJQynTZhy8GvorZBqCWo"

    return [
      "accept": "application/json",
      "Authorization": "Bearer \(apiAccessToken)"
    ]
  }
}
