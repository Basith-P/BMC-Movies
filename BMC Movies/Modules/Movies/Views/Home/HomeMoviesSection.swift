//
//  HomeMoviesSection.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

struct HomeMoviesSection: View {
  let title: String
  let movies: [Movie]

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.rounded(.title2, weight: .bold))
        .padding(.leading)
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          ForEach(movies) { movie in
            NavigationLink {
              MovieDetailsPage(movie: movie)
            } label: {
              MovieCard(movie: movie)
            }
          }
        }
        .padding(.horizontal)
      }
    }
  }
}

#Preview {
  HomeMoviesSection(title: "Now Playing", movies: Movie.sampleList)
}
