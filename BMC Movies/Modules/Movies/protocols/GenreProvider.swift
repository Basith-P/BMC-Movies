//
//  GenreProvider.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

protocol GenreProvider {
  func genreName(for id: Int) -> String?
}
