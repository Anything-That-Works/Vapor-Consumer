//
//  SongListViewModel.swift
//  Vapor Consumer
//
//  Created by Promal on 9/10/23.
//

import Foundation

class SongListViewModel: ObservableObject {
  @Published var songs = [Song]()
  
  func fetchSongs() async throws {
    let urlString = Constants.baseURL + EndPoints.songs
    
    guard let url = URL(string: urlString) else {
      throw HttpError.badURL
    }
    
    let songResponse: [Song] = try await HttpClient.shared.fetch(url: url)
    
    DispatchQueue.main.async {
      self.songs = songResponse
    }
  }
  
  func delete(at offsets: IndexSet) {
    offsets.forEach { i in
      guard let songID = songs[i].id else {
        return print("Can't find ID")
      }
      
      let urlString = Constants.baseURL + EndPoints.songs + "/\(songID)"
      
      guard let url = URL(string: urlString) else {
        return print("Error: \(HttpError.badURL)")
      }
      
      Task {
        do {
          try await HttpClient.shared.delete(at: songID, url: url)
          DispatchQueue.main.async {
            self.songs.remove(atOffsets: offsets)
          }
        } catch {
          return print("Error: \(error)")
        }
      }
    }
  }
  
}
