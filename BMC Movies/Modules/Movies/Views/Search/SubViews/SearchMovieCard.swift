//
//  SearchMovieCard.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Kingfisher
import SwiftUI

struct SearchMovieCard: View {
  let movie: Movie
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Movie Poster
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(
            LinearGradient(
              colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
        
        if let posterURL = movie.posterURL {
          KFImage(posterURL)
            .resizable()
            .fade(duration: 0.25)
            .placeholder {
              VStack(spacing: 8) {
                Image(systemName: "photo")
                  .font(.system(size: 24))
                  .foregroundColor(.white.opacity(0.5))
                ProgressView()
                  .scaleEffect(0.8)
              }
            }
            .aspectRatio(contentMode: .fill)
        } else {
          VStack(spacing: 8) {
            Image(systemName: "photo")
              .font(.system(size: 32))
              .foregroundColor(.cForeground.opacity(0.5))
            Text("No Image")
              .font(.caption)
              .foregroundColor(.cForeground.opacity(0.5))
          }
        }

        VStack {
          HStack {
            Spacer()
            HStack(spacing: 4) {
              Image(systemName: "star.fill")
                .font(.system(size: 10))
                .foregroundColor(.yellow)
              Text(String(format: "%.1f", movie.voteAverage))
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.black.opacity(0.7)))
          }
          Spacer()
        }
        .padding(12)
      }
      .aspectRatio(2/3, contentMode: .fill)
      .clipShape(RoundedRectangle(cornerRadius: 16))

      VStack(alignment: .leading, spacing: 6) {
        Text(movie.title)
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        if !movie.releaseDate.isEmpty {
          Text(String(movie.releaseDate.prefix(4)))
            .font(.system(size: 13, weight: .medium))
            .opacity(0.7)
        }
      }
      .frame(height: 60, alignment: .topLeading)
    }
  }
}
