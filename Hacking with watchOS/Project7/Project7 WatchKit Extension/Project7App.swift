//
//  Project7App.swift
//  Project7 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 01/08/22.
//

import SwiftUI

@main
struct Project7App: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
