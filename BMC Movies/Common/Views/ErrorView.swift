//
//  ErrorView.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI

struct ErrorView: View {
  let title: String
  let message: String
  let retryAction: (() -> Void)?

  init(
    title: String = "Something Went Wrong",
    message: String = "Please try again later.",
    retryAction: (() -> Void)? = nil
  ) {
    self.title = title
    self.message = message
    self.retryAction = retryAction
  }

  var body: some View {
    VStack(spacing: 28) {
      ZStack {
        Circle()
          .fill(Color.red.opacity(0.2))
          .frame(width: 100, height: 100)

        Image(systemName: "exclamationmark.triangle")
          .font(.system(size: 40, weight: .light))
          .foregroundColor(.red)
      }

      VStack(spacing: 8) {
        Text(title)
          .font(.system(size: 24, weight: .bold, design: .rounded))

        Text(message)
          .font(.system(size: 16, weight: .medium))
          .opacity(0.7)
          .multilineTextAlignment(.center)
      }
      .foregroundColor(Color.primary)

      if let retryAction {
        Button(action: retryAction) {
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
    }
    .padding()
  }
}

#Preview {
  ErrorView(retryAction: { })
}
