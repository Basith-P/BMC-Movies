//
//  MovieDetailsPage.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailsPage: View {
  let movie: Movie

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 16) {
        // --- Backdrop and Poster ---
        ZStack(alignment: .bottomLeading) {
          KFImage(movie.backdropURL)
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: 320)
            .overlay(
              LinearGradient(
                gradient: Gradient(colors: [.clear, Color.cBackground]),
                startPoint: .center,
                endPoint: .bottom
              )
            )

          HStack(alignment: .bottom, spacing: 16) {
            KFImage(movie.posterURL)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 120, height: 180)
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .shadow(radius: 10)

            VStack(alignment: .leading, spacing: 4) {
              Text(movie.title)
                .font(.rounded(.title2, weight: .bold))
                .lineLimit(3)
              Text(movie.releaseDate)
                .font(.rounded(.subheadline))
                .opacity(0.8)
                .padding(.bottom)
            }
          }
          .padding(.horizontal)
          .offset(y: 30)
        }
        .padding(.bottom, 60)

        // --- Rating ---
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text(String(format: "%.1f", movie.voteAverage))
            .font(.rounded(.callout, weight: .semibold))
          Text("(\(movie.voteCount) reviews)")
            .font(.rounded(.caption))
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)

        // --- Overview ---
        VStack(alignment: .leading, spacing: 8) {
          Text("Overview")
            .font(.rounded(.title3, weight: .bold))
          Text(movie.overview)
            .font(.rounded(.callout))
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)

        Spacer()
      }
    }
    .multilineTextAlignment(.leading)
    .navigationTitle(movie.title)
    .navigationBarTitleDisplayMode(.inline)
    .ignoresSafeArea(edges: .top)
    .background(Color.cBackground.ignoresSafeArea())
  }
}

#Preview {
  NavigationView {
    MovieDetailsPage(movie: Movie.sampleList.first!)
  }
}
