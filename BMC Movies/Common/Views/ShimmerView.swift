//
//  ShimmerView.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import SwiftUI

struct ShimmerView: View {
  @State private var toggleAnimate: Bool = false

  var body: some View {
    Color.gray
      .opacity(toggleAnimate ? 0.3 : 0.2)
      .animation(.linear(duration: 1).repeatForever(), value: toggleAnimate)
      .onAppear {
        toggleAnimate = true
      }
  }
}
