//
//  AddUpdateSong.swift
//  Vapor Consumer
//
//  Created by Promal on 9/10/23.
//

import SwiftUI

struct AddUpdateSong: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var viewModel = AddUpdateSongViewModel()
  var body: some View {
    VStack {
      TextField("Song Title", text: $viewModel.songTitle)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      Button {
        viewModel.addUpdateAction {
          presentationMode.wrappedValue.dismiss()
        }
      } label: {
        Text(viewModel.buttonTitle)
      }
    }
  }
}

#Preview {
  AddUpdateSong(viewModel: AddUpdateSongViewModel())
}
