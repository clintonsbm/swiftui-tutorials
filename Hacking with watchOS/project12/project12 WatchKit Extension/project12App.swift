//
//  project12App.swift
//  project12 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 16/08/22.
//

import SwiftUI

@main
struct project12App: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
