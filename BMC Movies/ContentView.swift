//
//  ContentView.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var moviesVM: MoviesViewModel

  let haptic = UIImpactFeedbackGenerator()

  init() {
#if DEBUG
    let isUITest = ProcessInfo.processInfo.arguments.contains("UI_TESTS")
    _moviesVM = .init(wrappedValue: .init(networkService: isUITest ? MockNetworkService() : URLSessionNetworkService()))
#else
    _moviesVM = .init(wrappedValue: .init())
#endif
    haptic.prepare()
  }

  @State private var selectedTab = 0
  
  var body: some View {
    TabView(selection: $selectedTab) {
      HomePage(moviesVM: moviesVM)
        .tabItem {
          Label("Home", systemImage: selectedTab == 0 ? "house.fill": "house")
        }
        .tag(0)
      SearchPage(moviesVM: moviesVM)
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(1)
      FavoritesPage()
        .tabItem {
          Label("Favorites", systemImage: selectedTab == 2 ? "heart.fill" : "heart")
        }
        .tag(2)
    }
    .onChange(of: selectedTab) { _ in
      haptic.impactOccurred()
    }
  }
}

#Preview {
  ContentView()
}
