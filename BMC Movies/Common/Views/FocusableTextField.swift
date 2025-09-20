//
//  FocusableTextField.swift
//  BMC Movies
//
//  Created by Basith P on 20/09/25.
//

import SwiftUI

@available(iOS 15.0, *)
struct FocusableTextField: View {
  let titleKey: LocalizedStringKey
  @Binding var text: String

  @FocusState private var isFocused: Bool

  var body: some View {
    TextField(titleKey, text: $text)
      .focused($isFocused)
      .onAppear {
        isFocused = true
      }
  }
}

#Preview {
  if #available(iOS 15.0, *) {
    FocusableTextField(titleKey: "Search", text: .constant(""))
  }
}
