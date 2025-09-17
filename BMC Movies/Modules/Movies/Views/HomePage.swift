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
    ScrollView {
      VStack(alignment: .leading) {
        Text("Now Playing").padding(.leading)
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack {
            ForEach(Movie.sampleList) { movie in
              ZStack {
                Color.red
                
              }
              .aspectRatio(2 / 3, contentMode: .fill)
              .frame(width: 160)
            }
          }
          .padding(.horizontal)
        }
      }
      .padding(.vertical)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .navigationTitle("Movies")
  }
}

#Preview {
  NavigationView {
    HomePage(moviesVM: MoviesViewModel())
  }
}
