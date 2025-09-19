//
//  MovieCard.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Kingfisher
import SwiftUI

struct MovieCard: View {
  let movie: Movie
  @StateObject private var favoritesManager = FavoritesManager.shared
  
  var body: some View {
    ZStack {
      Color.gray.opacity(0.3)
      KFImage(movie.posterURL)
        .resizable()
        .fade(duration: 0.25)
        .placeholder {
          ProgressView()
        }
      LinearGradient(colors: [.black.opacity(0), .black.opacity(0.3), .black], startPoint: .top, endPoint: .bottom)
      VStack(alignment: .leading) {
        Text(movie.title)
          .font(.rounded(.headline, weight: .semibold))
          .lineLimit(2)
        Group {
          Text(String(format: "%.2f", movie.voteAverage)) +
          Text("/10")
        }
        .font(.rounded(.caption, weight: .semibold)).opacity(0.7)
      }
      .foregroundColor(.white)
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
    .multilineTextAlignment(.leading)
    .aspectRatio(2 / 3, contentMode: .fill)
    .frame(width: 160)
    .clipShape(.rect(cornerRadius: 20))
    .overlay(
      Button {
        favoritesManager.toggleFavorite(movie)
      } label: {
        Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
          .foregroundColor(favoritesManager.isFavorite(movie) ? .accent : .white)
          .font(.title2)
          .shadow(radius: 4)
      }
      .padding(8)
      .accessibilityIdentifier(AccessibilyId.favoritesButton),
      alignment: .topTrailing
    )
  }
}

#Preview {
  HomePage(moviesVM: MoviesViewModel())
}
