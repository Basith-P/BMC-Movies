//
//  HomeMoviesSection.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

struct HomeMoviesSection: View {
  let title: String
  let sectionAccessibiliyId: String
  let moviesState: LoadableState<[Movie]>

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.rounded(.title2, weight: .bold))
        .padding(.leading)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          if let movies = moviesState.value {
            ForEach(movies) { movie in
              NavigationLink {
                MovieDetailsPage(movie: movie)
              } label: {
                MovieCard(movie: movie)
              }
              .accessibilityIdentifier(AccessibilyId.movieCard(sectionId: sectionAccessibiliyId, movieId: movie.id))
            }
          } else if moviesState.isLoading {
            ForEach(0..<5, id: \.self) { _ in movieCardPlaceholder() }
          } else if let _ = moviesState.error {
            Text("Something Went Wrong")
              .padding(.vertical, 32)
          }
        }
        .padding(.horizontal)
      }
    }
  }
}

#Preview {
  HomeMoviesSection(
    title: "Now Playing",
    sectionAccessibiliyId: AccessibilyId.nowPlaying,
    moviesState: .failed(NSError(domain: "Test Error", code: 0, userInfo: nil))
  )
}

extension HomeMoviesSection {
  @ViewBuilder
  private func movieCardPlaceholder() -> some View {
    ShimmerView()
      .aspectRatio(2 / 3, contentMode: .fill)
      .frame(width: 160)
      .clipShape(.rect(cornerRadius: 20))
  }
}
