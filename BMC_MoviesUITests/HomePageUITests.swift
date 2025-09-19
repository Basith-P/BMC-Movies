//
//  HomePageUITests.swift
//  BMC_MoviesUITests
//
//  Created by Basith Lascade on 19/09/25.
//

@testable import BMC_Movies
import XCTest

@MainActor
final class HomePageUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launchArguments = ["UI_TESTS"]
    app.launch()
  }

  override func tearDownWithError() throws {
  }

  func test_HomePage_MovieCards_ShouldNavigateToDetails() {
    let firstMovieId = 278
    let firstMovieCardId = AccessibilyId.movieCard(sectionId: AccessibilyId.nowPlaying, movieId: firstMovieId)
    let movieCard = app.buttons[firstMovieCardId]
    let firstMovieTitle = "The Shawshank Redemption"

    XCTAssertTrue(movieCard.waitForExistence(timeout: 5))

    movieCard.tap()

    XCTAssertTrue(app.staticTexts[firstMovieTitle].waitForExistence(timeout: 2))
    XCTAssertTrue(app.staticTexts["Overview"].waitForExistence(timeout: 2))
  }

  func test_MovieCard_favoriteButton_shoiuldToggleFavorite() {

    let firstMovieId = 278
    let firstMovieCardId = AccessibilyId.movieCard(sectionId: AccessibilyId.nowPlaying, movieId: firstMovieId)
    let movieCard = app.buttons[firstMovieCardId]
    let firstMovieFavoritesButton = movieCard.buttons[AccessibilyId.favoritesButton]

    firstMovieFavoritesButton.tap()

    let favoritesTab = app.buttons["Favorites"]
    favoritesTab.tap()

    let favoriteMovieCard = app.buttons[AccessibilyId.favoriteMovieCard(movieId: firstMovieId)]
    XCTAssertTrue(favoriteMovieCard.waitForExistence(timeout: 2))

    let favoriteCardFavoriteButton = favoriteMovieCard.buttons[AccessibilyId.favoritesButton]
    favoriteCardFavoriteButton.tap()

    XCTAssertFalse(favoriteMovieCard.waitForExistence(timeout: 2))
  }
}
