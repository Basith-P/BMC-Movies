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
