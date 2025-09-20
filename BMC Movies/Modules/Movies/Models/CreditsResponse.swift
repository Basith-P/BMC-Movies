//
//  CreditsResponse.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import Foundation

struct CreditsResponse: Decodable, Equatable {
  let id: Int
  let cast: [CastMember]
  let crew: [CrewMember]
}

struct CastMember: Decodable, Identifiable, Equatable {
  let id: Int
  let name: String
  let character: String?
  let order: Int?
  let profilePath: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case character
    case order
    case profilePath = "profile_path"
  }

  var profileURL: URL? {
    guard let profilePath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/w185/\(profilePath)")
  }
}

struct CrewMember: Decodable, Identifiable, Equatable {
  let id: Int
  let name: String
  let job: String?
  let department: String?
  let profilePath: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case job
    case department
    case profilePath = "profile_path"
  }

  var profileURL: URL? {
    guard let profilePath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/w185/\(profilePath)")
  }
}
