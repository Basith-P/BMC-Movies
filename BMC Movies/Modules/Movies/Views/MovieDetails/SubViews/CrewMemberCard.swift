//
//  CrewMemberCard.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI
import Kingfisher

struct CrewMemberCard: View {
  let crew: CrewMember

  var body: some View {
    VStack(spacing: 10) {
      avatarView
      VStack(spacing: 2) {
        Text(crew.name)
          .font(.system(size: 14, weight: .semibold, design: .rounded))
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .frame(maxWidth: .infinity)
        if let job = crew.job, !job.isEmpty {
          Text(job)
            .font(.system(size: 12, weight: .regular, design: .rounded))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
        }
      }
      .frame(maxWidth: 100, maxHeight: .infinity, alignment: .top)
    }
  }

  @ViewBuilder private var avatarView: some View {
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

      if let url = crew.profileURL {
        KFImage(url)
          .resizable()
          .fade(duration: 0.25)
          .aspectRatio(contentMode: .fill)
          .clipShape(Circle())
          .frame(width: 80, height: 80)
      } else {
        Image(systemName: "person.crop.square")
          .font(.system(size: 28))
          .foregroundColor(.cForeground.opacity(0.5))
      }
    }
  }
}
