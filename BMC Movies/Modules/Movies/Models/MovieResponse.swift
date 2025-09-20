//
//  MovieResponse.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Foundation

struct MovieResponse: Decodable {
  let page: Int
  let results: [Movie]
  let totalPages: Int
  let totalResults: Int

  enum CodingKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}
