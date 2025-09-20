//
//  MoviesGridView.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI

struct MoviesGridView: View {
  let movies: [Movie]

  private let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(movies) { movie in
        NavigationLink {
          MovieDetailsPage(movie: movie)
        } label: {
          MovieCard(movie: movie)
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, 20)
  }
}
