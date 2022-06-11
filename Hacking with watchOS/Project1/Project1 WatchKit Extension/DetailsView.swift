//
//  DetailsView.swift
//  Project1 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 11/06/22.
//

import SwiftUI

struct DetailsView: View {
  let index: Int
  let totalOfNotes: Int
  let note: Note
  
  var body: some View {
    Text(note.text)
      .lineLimit(3)
      .navigationTitle("\(index+1)/\(totalOfNotes)")
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    DetailsView(index: 1, totalOfNotes: 10, note: .init(id: .init(), text: "Hello, World!"))
  }
}
