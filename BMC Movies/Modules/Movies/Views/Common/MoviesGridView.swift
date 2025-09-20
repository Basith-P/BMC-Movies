//
//  MoviesGridView.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI

struct MoviesGridView: View {
  let movies: [Movie]
  var onReachEnd: (() -> Void)? = nil
  var prefetchThreshold: Int = 4

  private let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
        NavigationLink {
          MovieDetailsPage(movie: movie)
        } label: {
          MovieCard(movie: movie)
        }
        .buttonStyle(.plain)
        .id(movie.id)
        .onAppear {
          if index >= movies.count - prefetchThreshold {
            onReachEnd?()
          }
        }
      }
    }
    .padding(.horizontal, 20)
  }
}
