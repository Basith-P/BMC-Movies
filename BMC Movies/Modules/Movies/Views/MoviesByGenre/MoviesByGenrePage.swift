//
//  MoviesByGenrePage.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI

struct MoviesByGenrePage: View {
  let genre: Genre
  @EnvironmentObject var moviesVM: MoviesViewModel
  @State private var sortOption: SortOption = .popularityDesc

  var body: some View {
    Group {
      switch moviesVM.moviesByGenre {
      case .idle, .loading:
        ProgressView()
      case .failed(_):
        ErrorView() {
          moviesVM.fetchMoviesByGenre(genreId: genre.id)
        }
      case .loaded(let movies):
        ScrollView {
          MoviesGridView(movies: movies)
        }
      }
    }
    .background(Color.cBackground.ignoresSafeArea())
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Menu {
          ForEach(SortOption.allCases) { option in
            Button(action: { sortOption = option }) {
              Text(option.displayName)
            }
          }
        } label: {
          Image(systemName: "arrow.up.arrow.down.circle")
        }
      }
    }
    .onChange(of: sortOption) { newValue in
      moviesVM.fetchMoviesByGenre(genreId: genre.id, sortBy: newValue)
    }
    .onAppear {
      moviesVM.fetchMoviesByGenre(genreId: genre.id, sortBy: sortOption)
    }
    .onDisappear {
      moviesVM.moviesByGenre = .idle
    }
    .navigationTitle(genre.name)
  }
}

#Preview {
  MoviesByGenrePage(genre: .init(id: 1, name: "test"))
}
