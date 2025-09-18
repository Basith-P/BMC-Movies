//
//  FavoritesPage.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import SwiftUI

struct FavoritesPage: View {
  @StateObject private var favoritesManager = FavoritesManager.shared
  
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    NavigationView {
      Group {
        if favoritesManager.favoriteMovies.isEmpty {
          emptyStateView
        } else {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
              ForEach(favoritesManager.favoriteMovies) { movie in
                NavigationLink {
                  MovieDetailsPage(movie: movie)
                } label: {
                  MovieCard(movie: movie)
                }
              }
            }
            .padding()
          }
        }
      }
      .navigationTitle("Favorites")
      .navigationBarTitleDisplayMode(.large)
      .background(Color.cBackground.ignoresSafeArea())
    }
  }
  
  private var emptyStateView: some View {
    VStack(spacing: 16) {
      ZStack {
        Circle()
          .fill(
            LinearGradient(
              colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 120, height: 120)

        Image(systemName: "heart.slash")
          .font(.system(size: 50, weight: .regular))
          .opacity(0.5)
      }

      Text("No Favorites Yet")
        .font(.title2)
        .fontWeight(.semibold)
      
      Text("Start adding movies to your favorites by tapping the heart icon on any movie card.")
        .font(.body)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .frame(maxWidth: 300)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  FavoritesPage()
}
