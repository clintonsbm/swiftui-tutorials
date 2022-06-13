//
//  ContentView.swift
//  Project1 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 10/06/22.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("lineCount") var lineCount = 1
  
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
          
          saveNotes()
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
              .lineLimit(lineCount)
          }
        }
        .onDelete(perform: delete)
        
        Button("Lines: \(lineCount)") {
          lineCount += 1
          lineCount = lineCount == 4 ? 1 : lineCount
        }
        
        NavigationLink(destination: CreditsView()) {
          Image(systemName: "info.circle")
            .padding()
          Text("Credits")
        }
        .buttonStyle(BorderedButtonStyle(tint: .gray))
      }
    }
    .navigationTitle("NoteDictate")
    .onAppear(perform: loadNotes)
  }
  
  private func delete(offsets: IndexSet) {
    notes.remove(atOffsets: offsets)
    saveNotes()
  }
  
  private func saveNotes() {
    DispatchQueue.main.async {
      do {
        let data = try JSONEncoder().encode(notes)
        let url = getDocumentsDirectory().appendingPathComponent("notes")
        try data.write(to: url)
      } catch {
        print("Save failed with error: ", error)
      }
    }
  }
  
  private func loadNotes() {
    do {
      let url = getDocumentsDirectory().appendingPathComponent("notes")
      let data = try Data(contentsOf: url)
      notes = try JSONDecoder().decode([Note].self, from: data)
    } catch {
      print("Load notes failed with error: ", error)
    }
  }
  
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
