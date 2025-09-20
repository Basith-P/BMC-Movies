//
//  SortOption.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
  case popularityDesc = "popularity.desc"
  case popularityAsc = "popularity.asc"
  case releaseDateDesc = "primary_release_date.desc"
  case releaseDateAsc = "primary_release_date.asc"
  case revenueDesc = "revenue.desc"
  case revenueAsc = "revenue.asc"
  case voteAverageDesc = "vote_average.desc"
  case voteAverageAsc = "vote_average.asc"
  case voteCountDesc = "vote_count.desc"
  case voteCountAsc = "vote_count.asc"
  case titleDesc = "title.desc"
  case titleAsc = "title.asc"

  var id: Self { self }

  var displayName: String {
    switch self {
    case .popularityDesc: "Popularity (High to Low)"
    case .popularityAsc: "Popularity (Low to High)"
    case .releaseDateDesc: "Release Date (Newest)"
    case .releaseDateAsc: "Release Date (Oldest)"
    case .revenueDesc: "Revenue (High to Low)"
    case .revenueAsc: "Revenue (Low to High)"
    case .voteAverageDesc: "Rating (High to Low)"
    case .voteAverageAsc: "Rating (Low to High)"
    case .voteCountDesc: "Vote Count (High to Low)"
    case .voteCountAsc: "Vote Count (Low to High)"
    case .titleDesc: "Title (Z-A)"
    case .titleAsc: "Title (A-Z)"
    }
  }
}
