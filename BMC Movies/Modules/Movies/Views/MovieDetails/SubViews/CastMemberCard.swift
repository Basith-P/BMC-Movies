//
//  CastMemberCard.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI
import Kingfisher

struct CastMemberCard: View {
  let cast: CastMember

  var body: some View {
    VStack(spacing: 10) {
      ZStack {
        Circle()
          .fill(
            LinearGradient(
              colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 80, height: 80)

        if let url = cast.profileURL {
          KFImage(url)
            .resizable()
            .fade(duration: 0.25)
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: 80, height: 80)
        } else {
          Image(systemName: "person.fill")
            .font(.system(size: 32))
            .foregroundColor(.cForeground.opacity(0.5))
        }
      }

      VStack(spacing: 2) {
        Text(cast.name)
          .font(.system(size: 14, weight: .semibold, design: .rounded))
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .frame(maxWidth: .infinity)
        if let role = cast.character, !role.isEmpty {
          Text(role)
            .font(.system(size: 12, weight: .regular, design: .rounded))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
        }
      }
      .frame(maxWidth: 100, maxHeight: .infinity, alignment: .top)
    }
  }
}
