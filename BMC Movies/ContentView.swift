//
//  ContentView.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var moviesVM = MoviesViewModel()

  var body: some View {
    NavigationView {
      TabView {
        HomePage(moviesVM: moviesVM)
          .tabItem {
            Label("Home", systemImage: "house")
          }
        Text("Search")
          .tabItem {
            Label("Search", systemImage: "magnifyingglass")
          }
        Text("Favorites")
          .tabItem {
            Label("Favorites", systemImage: "heart")
          }
      }
    }
  }
}

#Preview {
  ContentView()
}
