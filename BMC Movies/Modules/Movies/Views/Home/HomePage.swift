//
//  HomePage.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

struct HomePage: View {
  @ObservedObject var moviesVM: MoviesViewModel
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 24) {
          HomeMoviesSection(
            title: "Now Playing",
            sectionAccessibiliyId: AccessibilyId.nowPlaying,
            moviesState: moviesVM.nowPlayingState
          )
          HomeMoviesSection(
            title: "Popular",
            sectionAccessibiliyId: AccessibilyId.popular,
            moviesState: moviesVM.popularState
          )
          HomeMoviesSection(
            title: "Top Rated",
            sectionAccessibiliyId: AccessibilyId.topRated,
            moviesState: moviesVM.topRatedState
          )
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .background(Color.cBackground.ignoresSafeArea())
      .navigationTitle("Movies")
    }
  }
}

#Preview {
  HomePage(moviesVM: MoviesViewModel())
}
