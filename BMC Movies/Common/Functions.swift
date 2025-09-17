//
//  Functions.swift
//  BMC Movies
//
//  Created by Basith P on 18/09/25.
//

import Foundation

func isIos15() -> Bool {
  if #available(iOS 15.0, *) {
    return true
  }
  return false
}
