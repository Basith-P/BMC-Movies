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
          HomeMoviesSection(title: "Now Playing", moviesState: moviesVM.nowPlayingState)
          HomeMoviesSection(title: "Popular", moviesState: moviesVM.popularState)
          HomeMoviesSection(title: "Top Rated", moviesState: moviesVM.topRatedState)
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
