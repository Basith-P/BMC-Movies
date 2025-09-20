//
//  Movie.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation

struct Movie: Codable, Identifiable, Equatable {
  let adult: Bool
  let backdropPath: String?
  let id: Int
  let title: String
  let originalTitle: String
  let overview: String
  let posterPath: String?
  let mediaType: String?
  let originalLanguage: String
  let genreIds: [Int]
  let popularity: Double
  let releaseDate: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int

  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case id
    case title
    case originalTitle = "original_title"
    case overview
    case posterPath = "poster_path"
    case mediaType = "media_type"
    case originalLanguage = "original_language"
    case genreIds = "genre_ids"
    case popularity
    case releaseDate = "release_date"
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }

  var posterURL: URL? {
    guard let posterPath = posterPath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
  }

  var backdropURL: URL? {
    guard let backdropPath = backdropPath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/w500/\(backdropPath)")
  }

  func genres(using provider: GenreProvider) -> [Genre] {
    genreIds.compactMap { id in
      guard let name = provider.genreName(for: id) else { return nil }
      return Genre(id: id, name: name)
    }
  }

  static func from(_ favoriteMovie: FavoriteMovie) -> Movie? {
    guard let title = favoriteMovie.title,
          let originalTitle = favoriteMovie.originalTitle,
          let overview = favoriteMovie.overview,
          let releaseDate = favoriteMovie.releaseDate,
          let originalLanguage = favoriteMovie.originalLanguage else {
      return nil
    }

    return Movie(
      adult: favoriteMovie.adult,
      backdropPath: favoriteMovie.backdropPath,
      id: Int(favoriteMovie.id),
      title: title,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: favoriteMovie.posterPath,
      mediaType: nil,
      originalLanguage: originalLanguage,
      genreIds: (favoriteMovie.genreIds as? [Int]) ?? [],
      popularity: favoriteMovie.popularity,
      releaseDate: releaseDate,
      video: false,
      voteAverage: favoriteMovie.voteAverage,
      voteCount: Int(favoriteMovie.voteCount)
    )
  }

  static var sampleList: [Movie] {
    [
      Movie(
        adult: false,
        backdropPath: "/pNjh59JSxChQktamG3LMp9ZoQzp.jpg",
        id: 278,
        title: "The Shawshank Redemption",
        originalTitle: "The Shawshank Redemption",
        overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
        posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
        mediaType: nil,
        originalLanguage: "en",
        genreIds: [18, 80],
        popularity: 31.6608,
        releaseDate: "1994-09-23",
        video: false,
        voteAverage: 8.712,
        voteCount: 28882
      ),
      Movie(
        adult: false,
        backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
        id: 238,
        title: "The Godfather",
        originalTitle: "The Godfather",
        overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.",
        posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
        mediaType: nil,
        originalLanguage: "en",
        genreIds: [18, 80],
        popularity: 27.0898,
        releaseDate: "1972-03-14",
        video: false,
        voteAverage: 8.686,
        voteCount: 21826
      ),
      Movie(
        adult: false,
        backdropPath: "/kGzFbGhp99zva6oZODW5atUtnqi.jpg",
        id: 240,
        title: "The Godfather Part II",
        originalTitle: "The Godfather Part II",
        overview: "In the continuing saga of the Corleone crime family, a young Vito Corleone grows up in Sicily and in 1910s New York. In the 1950s, Michael Corleone attempts to expand the family business into Las Vegas, Hollywood and Cuba.",
        posterPath: "/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg",
        mediaType: nil,
        originalLanguage: "en",
        genreIds: [18, 80],
        popularity: 17.3188,
        releaseDate: "1974-12-20",
        video: false,
        voteAverage: 8.57,
        voteCount: 13185
      ),
      Movie(
        adult: false,
        backdropPath: "/zb6fM1CX41D9rF9hdgclu0peUmy.jpg",
        id: 424,
        title: "Schindler's List",
        originalTitle: "Schindler's List",
        overview: "The true story of how businessman Oskar Schindler saved over a thousand Jewish lives from the Nazis while they worked as slaves in his factory during World War II.",
        posterPath: "/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg",
        mediaType: nil,
        originalLanguage: "en",
        genreIds: [18, 36, 10752],
        popularity: 15.5133,
        releaseDate: "1993-12-15",
        video: false,
        voteAverage: 8.566,
        voteCount: 16700
      )
    ]
  }
}
