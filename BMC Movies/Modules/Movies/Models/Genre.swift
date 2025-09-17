//
//  Genre.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Foundation

struct Genre: Codable, Identifiable, Hashable {
  let id: Int
  let name: String
}

struct GenreResponse: Codable {
  let genres: [Genre]
}
