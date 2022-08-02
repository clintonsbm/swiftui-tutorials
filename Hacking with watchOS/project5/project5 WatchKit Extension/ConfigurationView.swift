//
//  MainView.swift
//  project5 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 14/07/22.
//

import SwiftUI

struct ConfigurationView: View {
    private static let isColorBlingKey = "is_color_blind"
    
    @State private var isColorBlind = UserDefaults.standard.bool(forKey: Self.isColorBlingKey)
    
    var body: some View {
        Toggle(isOn: $isColorBlind) {
            Text("Color Blind mode")
        }.navigationTitle("Options")
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
