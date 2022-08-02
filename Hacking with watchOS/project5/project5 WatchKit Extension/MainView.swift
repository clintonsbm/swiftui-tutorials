//
//  MainView.swift
//  project5 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 27/07/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            TabView {
                ContentView()
                ConfigurationView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
