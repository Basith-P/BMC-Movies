//
//  ContentView.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var moviesVM = MoviesViewModel()
  
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
  }
}

#Preview {
  ContentView()
}
