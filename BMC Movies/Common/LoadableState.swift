//
//  LoadableState.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Foundation

enum LoadableState<Value> {
  case idle, loading, loaded(Value), failed(Error)

  var isLoading: Bool {
    if case .loading = self { return true }
    return false
  }

  var value: Value? {
    if case .loaded(let value) = self { return value }
    return nil
  }

  var error: Error? {
    if case .failed(let error) = self { return error }
    return nil
  }
}

extension LoadableState: Equatable where Value: Equatable {
  static func == (lhs: LoadableState<Value>, rhs: LoadableState<Value>) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.loading, .loading):
      return true
    case (.loaded(let lhsValue), .loaded(let rhsValue)):
      return lhsValue == rhsValue
    case (.failed(let lhsError), .failed(let rhsError)):
      return (lhsError as NSError) == (rhsError as NSError)
    default:
      return false
    }
  }
}
