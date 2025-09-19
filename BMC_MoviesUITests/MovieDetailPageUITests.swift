//
//  MovieDetailPageUITests.swift
//  BMC_MoviesUITests
//
//  Created by Basith Lascade on 19/09/25.
//

import XCTest

final class MovieDetailPageUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launchArguments = ["UI_TESTS"]
    app.launch()
  }

  override func tearDownWithError() throws {
  }

  func test_MovieDetailPage_favoriteButton_shouldToggleFavorite() throws {
    let firstMovieId = 278
    let firstMovieCardId = AccessibilyId.movieCard(sectionId: AccessibilyId.nowPlaying, movieId: firstMovieId)
    let movieCard = app.buttons[firstMovieCardId]

    XCTAssertTrue(movieCard.waitForExistence(timeout: 2))

    movieCard.tap()

    let favoritesButton = app.buttons[AccessibilyId.movieDetailPageFavoriteButton]

    favoritesButton.tap()

    let favoritesTab = app.buttons["Favorites"]
    favoritesTab.tap()

    let favoriteMovieCard = app.buttons[AccessibilyId.favoriteMovieCard(movieId: firstMovieId)]
    XCTAssertTrue(favoriteMovieCard.waitForExistence(timeout: 2))

    let favoriteCardFavoriteButton = favoriteMovieCard.buttons[AccessibilyId.favoritesButton]
    favoriteCardFavoriteButton.tap()

    XCTAssertFalse(favoriteMovieCard.waitForExistence(timeout: 2))
  }
}
