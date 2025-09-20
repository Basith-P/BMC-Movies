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
          moviesVM.fetchMoviesByGenre(genreId: genre.id, sortBy: sortOption)
        }
      case .loaded(let movies):
        ScrollView {
          MoviesGridView(
            movies: movies,
            onReachEnd: { moviesVM.loadMoreMoviesByGenre() },
          )
          if moviesVM.isLoadingMoreGenre {
            ProgressView()
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
          }
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
      if moviesVM.moviesByGenre.value == nil {
        moviesVM.fetchMoviesByGenre(genreId: genre.id, sortBy: sortOption)
      }
    }
    .navigationTitle(genre.name)
  }
}

#Preview {
  MoviesByGenrePage(genre: .init(id: 1, name: "test"))
}
