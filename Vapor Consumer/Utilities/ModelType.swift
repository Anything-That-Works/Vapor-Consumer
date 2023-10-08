//
//  ModelType.swift
//  Vapor Consumer
//
//  Created by Promal on 9/10/23.
//

import Foundation

enum ModelType: Identifiable {
  var id: String {
    switch self {
    case .add: return "Add"
    case .update: return "update"
    }
  }
  case add
  case update(Song)
}
