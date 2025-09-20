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

  @State private var hasMoviesAppeared: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.rounded(.title2, weight: .bold))
        .padding(.leading)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          if let movies = moviesState.value {
            ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
              NavigationLink {
                MovieDetailsPage(movie: movie)
              } label: {
                MovieCard(movie: movie)
              }
              .accessibilityIdentifier(AccessibilyId.movieCard(sectionId: sectionAccessibiliyId, movieId: movie.id))
              .offset(x: hasMoviesAppeared ? 0 : 30)
             .opacity(hasMoviesAppeared ? 1 : 0)
             .scaleEffect(hasMoviesAppeared ? 1 : 0.9)
             .animation(.smooth.delay(Double(index > 5 ? 5 : index) * 0.1), value: hasMoviesAppeared)
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
    .onChange(of: moviesState) { newvalue in
      if newvalue.value != nil, !hasMoviesAppeared {
        hasMoviesAppeared = true
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

// MARK: - SubViews
extension HomeMoviesSection {
  @ViewBuilder
  private func movieCardPlaceholder() -> some View {
    ShimmerView()
      .aspectRatio(2 / 3, contentMode: .fill)
      .frame(width: 160)
      .clipShape(.rect(cornerRadius: 20))
  }
}
