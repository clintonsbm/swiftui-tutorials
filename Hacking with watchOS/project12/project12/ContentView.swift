//
//  ContentView.swift
//  project12
//
//  Created by Clinton de Sá Barreto Maciel on 16/08/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var connectivity = Connectivity()
    
    var body: some View {
        VStack(spacing: 30) {
            Button("Message", action: sendMessage)
            Button("Context", action: sendContext)
            Button("File", action: sendFile)
            Button("Complication", action: sendComplication)
            VStack {
                Text("Text received: ")
                Text(connectivity.receivedText)
            }
        }
    }
    
    // MARK: Methods
    
    private func sendMessage() {
        let data = ["text": "User info from the phone"]
//        connectivity.transfer(userInfo: data)
        connectivity.send(message: data)
    }
    
    private func sendContext() {
        let data = ["text": "User info from the phone"]
        connectivity.setContext(to: data)
    }
    
    private func sendFile() {
        
    }
    
    private func sendComplication() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
