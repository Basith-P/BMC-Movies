//
//  Font+Extension.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import SwiftUI

extension Font {
  /// Creates a rounded system font with dynamic type support
  /// - Parameters:
  ///   - size: The base font size for the default content size category
  ///   - weight: The font weight (default: .regular)
  /// - Returns: A scalable font that adjusts based on the user's content size category
  static func rounded(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    return .system(size: size, weight: weight, design: .rounded)
  }

  /// Creates a rounded system font with dynamic type support that scales relative to the body font
  /// - Parameters:
  ///   - textStyle: The text style to use as a reference for scaling
  ///   - weight: The font weight (default: .regular)
  /// - Returns: A scalable font that adjusts based on the user's content size category
  static func rounded(_ textStyle: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
    return .system(textStyle, design: .rounded).weight(weight)
  }
}
