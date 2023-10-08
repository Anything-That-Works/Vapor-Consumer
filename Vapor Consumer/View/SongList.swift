//
//  SongList.swift
//  Vapor Consumer
//
//  Created by Promal on 8/10/23.
//

import SwiftUI

struct SongList: View {
  //MARK: Properties
  @StateObject var viewModel = SongListViewModel()
  @State var model: ModelType? = nil
  
  //MARK: View
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.songs) { song in
          Button {
            model = .update(song)
          } label: {
            Text(song.title)
              .font(.title3)
              .foregroundStyle(Color(.label))
          }
        }.onDelete(perform: viewModel.delete)
      }
      .navigationTitle("🎵Songs🎵")
      .toolbar {
        Button {
          model = .add
        } label: {
          Label("Add song", systemImage: "plus.circle")
        }
      }
      .sheet(item: $model, onDismiss: onSheetDismiss) { model in
        switch model {
        case .add:
          AddUpdateSong(viewModel: AddUpdateSongViewModel())
        case .update(let song):
          AddUpdateSong(viewModel: AddUpdateSongViewModel(currentSong: song))
        }
      }
      .onAppear(perform: fetchSongOnAppear)
    }
  }
  
  private func onSheetDismiss() {
    Task {
      do {
        try await viewModel.fetchSongs()
      } catch {
        print("Error: \(error)")
      }
    }
  }
  
  private func fetchSongOnAppear() {
    Task {
      do {
        try await viewModel.fetchSongs()
      } catch {
        print("❌Error: \(error)")
      }
    }
  }
  
}

#Preview("ContentView") {
  SongList()
}
