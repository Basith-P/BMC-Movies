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
          HomeMoviesSection(title: "Now Playing", movies: moviesVM.nowPlayingMovies)
          HomeMoviesSection(title: "Popular", movies: moviesVM.popularMovies)
          HomeMoviesSection(title: "Top Rated", movies: moviesVM.topRatedMovies)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .navigationTitle("Movies")
      .background(Color.cBackground.ignoresSafeArea())
    }
  }
}

#Preview {
  HomePage(moviesVM: MoviesViewModel())
}
