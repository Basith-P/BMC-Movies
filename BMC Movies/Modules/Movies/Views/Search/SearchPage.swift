//
//  SearchPage.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import SwiftUI

struct SearchPage: View {
  @ObservedObject var moviesVM: MoviesViewModel

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  SearchPage(moviesVM: MoviesViewModel())
}
