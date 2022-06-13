//
//  ContentView.swift
//  Project4 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 11/06/22.
//

import SwiftUI

struct ContentView: View {
  @State private var amount = 500.0
  
  var body: some View {
    VStack {
      Text("\(amount)")
        .font(.system(size: 52))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
