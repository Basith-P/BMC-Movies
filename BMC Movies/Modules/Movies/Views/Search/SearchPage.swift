//
//  SearchPage.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import SwiftUI
import Kingfisher

struct SearchPage: View {
  @ObservedObject var moviesVM: MoviesViewModel
  @State private var searchText = ""
  @State private var isSearching = false
  @State private var searchTimer: Timer?
  
  private let debounceDelay: TimeInterval = 0.5
  
  private let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]

  var body: some View {
    NavigationView {
      ZStack {
        Color.cBackground.ignoresSafeArea()

        switch moviesVM.searchResults {
        case .idle, .loading:
          EmptyView()
        case .loaded(let movies):
          if movies.isEmpty { noResultsView }
        case .failed(let error):
          errorView(error: error)
        }

        if #available(iOS 15.0, *) {
          if case .idle = moviesVM.searchResults {
            emptySearchState
          }

          ScrollView {
            searchResultsView
          }
          .safeAreaInset(edge: .top) { searchBar }
        } else {
          VStack(spacing: 0) {
            searchBar
            if searchText.isEmpty {
              emptySearchState
            } else {
              ScrollView {
                searchResultsView
              }
            }
          }
        }
      }
      .navigationTitle("Discover")
      .onDisappear {
        searchTimer?.invalidate()
      }
    }
  }
}

// MARK: - SubViews
extension SearchPage {
  @ViewBuilder
  var searchBarBackground: some View {
    if #available(iOS 15.0, *) {
      RoundedRectangle(cornerRadius: 16)
        .fill(.ultraThinMaterial)
    } else {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white.opacity(0.2))
    }
  }

  @ViewBuilder
  private var searchBar: some View {
    HStack(spacing: 12) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.cForeground.opacity(0.7))
        .font(.system(size: 18, weight: .medium))

      TextField("Search movies...", text: $searchText)
        .textFieldStyle(.plain)
        .foregroundColor(.cForeground)
        .font(.rounded(.callout, weight: .medium))
        .onChange(of: searchText) { newValue in
          searchTimer?.invalidate()
          
          if newValue.isEmpty {
            moviesVM.searchResults = .idle
            return
          }
          
          searchTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { _ in
            performSearch()
          }
        }

      if !searchText.isEmpty {
        Button(action: clearSearch) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.cForeground.opacity(0.7))
            .font(.system(size: 16))
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(
      searchBarBackground
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.cForeground.opacity(0.2), lineWidth: 1)
        )
    )
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSearching)
    .onTapGesture {
      isSearching = true
    }
  }

  private var emptySearchState: some View {
    VStack(spacing: 32) {
      Spacer()

      VStack(spacing: 20) {
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

          Image(systemName: "film.stack")
            .font(.system(size: 50, weight: .regular))
            .opacity(0.5)
        }

        VStack(spacing: 12) {
          Text("Discover Movies")
            .font(.rounded(.title, weight: .bold))

          Text("Search for movies, actors, directors and discover your next favorite film")
            .font(.rounded(.callout, weight: .medium))
            .opacity(0.7)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .frame(maxWidth: 300)
        }
      }

      Spacer()
    }
    .padding(.horizontal, 32)
  }
  
  private var searchResultsView: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      switch moviesVM.searchResults {
      case .idle, .failed:
        EmptyView()

      case .loading:
        ForEach(0..<6, id: \.self) { _ in
          searchResultPlaceholder
        }

      case .loaded(let movies):
        ForEach(movies) { movie in
          NavigationLink {
            MovieDetailsPage(movie: movie)
          } label: {
            SearchMovieCard(movie: movie)
          }
          .buttonStyle(.plain)
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 24)
  }
  
  private var noResultsView: some View {
    VStack(spacing: 24) {
      ZStack {
        Circle()
          .fill(Color.orange.opacity(0.2))
          .frame(width: 100, height: 100)
        
        Image(systemName: "questionmark.app.dashed")
          .font(.system(size: 40, weight: .light))
      }
      
      VStack(spacing: 12) {
        Text("No Movies Found")
          .font(.system(size: 24, weight: .bold, design: .rounded))
        
        Text("Try different keywords or check your spelling")
          .font(.system(size: 16, weight: .medium))
          .opacity(0.7)
          .multilineTextAlignment(.center)
      }
    }
    .padding(.top, 80)
    .padding(.horizontal)
    .frame(maxWidth: .infinity, alignment: .center)
    .multilineTextAlignment(.center)
  }
  
  private func errorView(error: Error) -> some View {
    VStack(spacing: 24) {
      ZStack {
        Circle()
          .fill(Color.red.opacity(0.2))
          .frame(width: 100, height: 100)
        	
        Image(systemName: "exclamationmark")
          .font(.system(size: 40, weight: .light))
          .foregroundColor(.red)
      }
      
      VStack(spacing: 12) {
        Text("Something went wrong")
          .font(.system(size: 24, weight: .bold, design: .rounded))
        
        Text("Please try again later")
          .font(.system(size: 16, weight: .medium))
          .opacity(0.7)
      }
      .multilineTextAlignment(.center)
      .foregroundColor(.cForeground)

      Button(action: performSearch) {
        HStack(spacing: 8) {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 14, weight: .semibold))
          Text("Try Again")
            .font(.system(size: 16, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
          RoundedRectangle(cornerRadius: 25)
            .fill(Color.blue.opacity(0.8))
        )
      }
    }
    .padding(.top, 80)
    .frame(maxWidth: .infinity)
  }
  
  private var searchResultPlaceholder: some View {
    ShimmerView()
      .aspectRatio(2/3, contentMode: .fill)
      .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}

// MARK: - Actions
extension SearchPage {
  private func performSearch() {
    guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    hideKeyboard()
    moviesVM.searchMovie(query: searchText)
  }
  
  private func clearSearch() {
    searchTimer?.invalidate()
    searchText = ""
    isSearching = false
    moviesVM.searchResults = .idle
  }
  
  private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

#Preview {
  SearchPage(moviesVM: MoviesViewModel())
}
