//
//  MainView.swift
//  Project4 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 13/06/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
      TabView {
        NavigationView {
          ContentView()          
        }
        CurrenciesView()
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
