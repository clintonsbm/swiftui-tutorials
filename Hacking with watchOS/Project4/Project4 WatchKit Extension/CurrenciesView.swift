//
//  CurrenciesView.swift
//  Project4 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 13/06/22.
//

import SwiftUI

struct CurrenciesView: View {
  @State private var selectedCurrencies = UserDefaults.standard.array(forKey: ContentView.selectedCurrenciesKey) as? [String] ?? ContentView.defaultCurrencies
  
  private let selectedColor = Color(red: 0, green: 0.55, blue: 0.25)
  private let deselectedColor = Color(red: 0.3, green: 0, blue: 0)
  
  var body: some View {
    List {
      ForEach(ContentView.currencies, id: \.self) { currency in
        Button(currency) {
          toggle(currency)
        }
        .listItemTint(selectedCurrencies.contains(currency) ? selectedColor : deselectedColor)
      }
    }
    .listStyle(CarouselListStyle())
    .navigationTitle("Currencies")
  }
  
  private func toggle(_ currency: String) {
    if let index = selectedCurrencies.firstIndex(of: currency) {
      // If present, remove
      selectedCurrencies.remove(at: index)
    } else {
      // Otherwise add
      selectedCurrencies.append(currency)
    }
    
    // Save
    UserDefaults.standard.set(selectedCurrencies, forKey: ContentView.selectedCurrenciesKey)
  }
}

struct CurrenciesView_Previews: PreviewProvider {
  static var previews: some View {
    CurrenciesView()
  }
}
