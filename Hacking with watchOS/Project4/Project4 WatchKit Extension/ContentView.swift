//
//  ContentView.swift
//  Project4 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 11/06/22.
//

import SwiftUI

struct ContentView: View {
  static let currencies = ["USD", "AUD", "CAD", "CHF", "CNY", "EUR", "GBP", "HKD", "JPY", "SGD"]
  static let selectedCurrenciesKey = "SelectedCurrencies"
  static let defaultCurrencies = ["USD", "EUR"]
  
  @State private var amount = 500.0
  @State private var selectedCurrency = "USD"
  
  var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        Text("\(Int(amount))")
          .font(.system(size: 52))
          .frame(height: geo.size.height / 3)
        
        Slider(value: $amount, in: 0...1000, step: 20)
          .tint(.green)
          .frame(height: geo.size.height / 3)
        
        HStack {
          Picker("Select a currency", selection: $selectedCurrency) {
            ForEach(Self.currencies, id: \.self) { currency in
              Text(currency)
            }
          }
          .labelsHidden()
          
          NavigationLink("Go") {
            ResultView(amount: amount, currency: selectedCurrency)
          }
          .frame(width: geo.size.width * 0.3)
        }
        .frame(height: geo.size.height / 3)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
