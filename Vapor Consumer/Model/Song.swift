//
//  Song.swift
//  Vapor Consumer
//
//  Created by Promal on 9/10/23.
//

import Foundation


struct Song: Identifiable, Codable {
  let id: UUID?
  var title: String
}
