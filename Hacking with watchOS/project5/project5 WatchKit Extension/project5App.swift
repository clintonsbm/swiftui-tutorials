//
//  project5App.swift
//  project5 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 18/06/22.
//

import SwiftUI

@main
struct project5App: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        TabView {
          ContentView()
            .tabItem {
              Text("Hey")
            }
          ConfigurationView()
        }
      }
    }
  }
}
