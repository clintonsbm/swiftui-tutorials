//
//  ContentView.swift
//  Project1 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 10/06/22.
//

import SwiftUI

struct ContentView: View {
  
  @State private var notes = [Note]()
  @State private var text = ""
  
  var body: some View {
    VStack {
      HStack {
        TextField("Add new note", text: $text)
        Button {
          guard !text.isEmpty else { return }
          
          let note = Note(id: .init(), text: text)
          notes.append(note)
          
          text = ""
        } label: {
          Image(systemName: "plus")
            .padding()
        }
        .fixedSize()
        .buttonStyle(BorderedButtonStyle(tint: .blue))
      }
      
      List {
        let totalOfNotes = notes.count
        ForEach(0..<totalOfNotes, id: \.self) { index in
          NavigationLink(destination: DetailsView(index: index, totalOfNotes: totalOfNotes, note: notes[index])) {
            Text(notes[index].text)
          }
        }
        .onDelete(perform: delete)
        
        NavigationLink(destination: CreditsView()) {
          Image(systemName: "info.circle")
            .padding()
          Text("Credits")
        }
        .buttonStyle(BorderedButtonStyle(tint: .gray))
      }
    }
    .navigationTitle("NoteDictate")
  }
  
  private func delete(offsets: IndexSet) {
    withAnimation {
      notes.remove(atOffsets: offsets)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
