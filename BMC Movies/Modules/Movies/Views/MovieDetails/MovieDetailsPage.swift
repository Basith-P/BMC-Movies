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

  @ObservedObject private var genreCache = GenreCache.shared
  @State private var movieGenres: [Genre] = []

  @ObservedObject var favoritesManager = FavoritesManager.shared
  @StateObject private var detailsVM = MovieDetailsViewModel()

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 20) {
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
            Rectangle()
              .fill(Color.primary.opacity(0.1))
              .overlay(
                KFImage(movie.posterURL)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
              )
              .frame(width: 120, height: 180)
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .shadow(radius: 10)

            VStack(alignment: .leading, spacing: 4) {
              Text(movie.title)
                .font(.rounded(.title2, weight: .bold))
                .lineLimit(3)
              Text(movie.formattedReleaseDate)
                .font(.rounded(.subheadline))
                .opacity(0.8)
                .padding(.bottom)
            }
          }
          .padding(.horizontal)
          .offset(y: 30)
        }
        .padding(.bottom, 60)

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

        VStack(alignment: .leading, spacing: 8) {
          Text("Overview")
            .font(.rounded(.title3, weight: .bold))
          Text(movie.overview)
            .font(.rounded(.callout))
            .foregroundColor(.secondary)
        }
        .padding(.horizontal)

        if !movieGenres.isEmpty {
          VStack(alignment: .leading, spacing: 8) {
            Text("Genres")
              .font(.rounded(.title3, weight: .bold))
              .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(movieGenres) { genre in
                  Text(genre.name)
                    .font(.rounded(.caption, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                }
              }
              .padding(.horizontal)
            }
          }
        }

        creditsContent
      }
      .padding(.bottom)
    }
    .multilineTextAlignment(.leading)
    .navigationTitle(movie.title)
    .navigationBarTitleDisplayMode(.inline)
    .ignoresSafeArea(edges: .top)
    .background(Color.cBackground.ignoresSafeArea())
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          favoritesManager.toggleFavorite(movie)
        } label: {
          Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
            .foregroundColor(favoritesManager.isFavorite(movie) ? .accent : .white)
            .font(.title2)
            .shadow(radius: 4)
        }
        .accessibilityIdentifier(AccessibilyId.movieDetailPageFavoriteButton)
      }
    }
    .onAppear {
      movieGenres = movie.genres(using: genreCache)
      detailsVM.fetchCredits(movieId: movie.id)
    }
    .onChange(of: genreCache.genres) { genres in
      movieGenres = movie.genres(using: genreCache)
    }
  }
}

// MARK: - Credits Sections
extension MovieDetailsPage {
  @ViewBuilder
  private var creditsContent: some View {
    switch detailsVM.creditsState {
    case .idle, .loading:
      VStack(alignment: .leading, spacing: 16) {
        Text("Cast")
          .font(.rounded(.title3, weight: .bold))
          .padding(.horizontal)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach(0..<8, id: \.self) { _ in
              VStack(spacing: 10) {
                ShimmerView()
                  .frame(width: 80, height: 80)
                  .clipShape(Circle())
                ShimmerView()
                  .frame(width: 90, height: 12)
                  .clipShape(RoundedRectangle(cornerRadius: 4))
              }
              .frame(width: 100)
            }
          }
          .padding(.horizontal)
        }

        Text("Crew")
          .font(.rounded(.title3, weight: .bold))
          .padding(.horizontal)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 16) {
            ForEach(0..<8, id: \.self) { _ in
              VStack(spacing: 10) {
                ShimmerView()
                  .frame(width: 80, height: 80)
                  .clipShape(Circle())
                ShimmerView()
                  .frame(width: 90, height: 12)
                  .clipShape(RoundedRectangle(cornerRadius: 4))
              }
              .frame(width: 100)
            }
          }
          .padding(.horizontal)
          .padding(.bottom, 8)
        }
      }

    case .loaded(let credits):
      VStack(alignment: .leading, spacing: 16) {
        if !credits.cast.isEmpty {
          Text("Cast")
            .font(.rounded(.title3, weight: .bold))
            .padding(.horizontal)
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(credits.cast.sorted(by: { (lhs, rhs) in
                (lhs.order ?? Int.max) < (rhs.order ?? Int.max)
              })) { cast in
                CastMemberCard(cast: cast)
              }
            }
            .padding(.horizontal)
          }
        }

        if !credits.crew.isEmpty {
          Text("Crew")
            .font(.rounded(.title3, weight: .bold))
            .padding(.horizontal)
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(Array(credits.crew.prefix(20))) { crew in
                CrewMemberCard(crew: crew)
              }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
          }
        }
      }

    case .failed(_):
      ErrorView(retryAction: { detailsVM.fetchCredits(movieId: movie.id) })
    }
  }
}

#Preview {
  NavigationView {
    MovieDetailsPage(movie: Movie.sampleList.first!)
  }
}
