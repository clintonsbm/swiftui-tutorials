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
  static let selectedBaseCurrencyKey = "SelectedBaseCurrency"
  static let defaultCurrencies = ["USD", "EUR"]
  
  @State private var amount = 500.0
  @State private var selectedCurrency = UserDefaults.standard.string(forKey: Self.selectedBaseCurrencyKey) ?? "USD"
  @FocusState private var isAmountFocused
  
  var body: some View {
    GeometryReader { geo in
      VStack() {
        Text("\(Int(amount))")
          .font(.system(size: 52))
          .padding()
          .frame(width: geo.size.width)
          .contentShape(Rectangle())
          .focusable()
          .focused($isAmountFocused)
          .digitalCrownRotation($amount, from: 0, through: 1000, by: 20, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .strokeBorder(isAmountFocused ? Color.green : Color.white, lineWidth: 1)
          )
          .padding(.bottom)
        
        HStack {
          Picker("Select a currency", selection: $selectedCurrency) {
            ForEach(Self.currencies, id: \.self) { currency in
              Text(currency)
            }
          }
          .labelsHidden()
          
          NavigationLink("Go") {
            ResultView(amount: amount, baseCurrency: selectedCurrency)
          }
          .frame(width: geo.size.width * 0.3)
        }
        .frame(height: geo.size.height / 3)
      }
    }
  }
  
  private func saveSelectedCurrency() {
    UserDefaults.standard.set(selectedCurrency, forKey: Self.selectedBaseCurrencyKey)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
