//
//  GenresPage.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI

struct GenresPage: View {
  @ObservedObject private var genreCache = GenreCache.shared

  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        LazyVStack {
          ForEach(genreCache.genres) { genre in
            NavigationLink(destination: MoviesByGenrePage(genre: genre)) {
              HStack {
                Text(genre.name).font(.rounded(.headline, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right")
              }
              .foregroundColor(.primary)
              .padding()
              .background(Color.primary.opacity(0.1))
              .cornerRadius(16)
            }
          }
        }
        .padding()
      }
      .navigationTitle("Genres")
      .background(Color.cBackground.ignoresSafeArea())
    }
  }
}

#Preview {
  GenresPage()
}
