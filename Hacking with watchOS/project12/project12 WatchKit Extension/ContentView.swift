//
//  ContentView.swift
//  project12 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 16/08/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var connectivity = Connectivity()
    
    var body: some View {
        VStack {
            VStack {
                Text("Text received: ")
                Text(connectivity.receivedText)
            }
            Button("Message", action: sendMessage)
        }
    }
    
    // MARK: Methods
    
    private func sendMessage() {
        let data = ["text": "User info from the watch"]
        connectivity.transfer(userInfo: data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
