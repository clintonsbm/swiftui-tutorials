//
//  ResultView.swift
//  Project4 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 13/06/22.
//

import SwiftUI
import Combine

struct ResultView: View {
  static let appID = "23fb941fe2114a85af6f111b7418c905"
  
  @State var fetchState = FetchState.fetching
  @State private var fetchedCurrencies = [(symbol: String, rate: Double)]()
  @State private var request: AnyCancellable?
  
  let amount: Double
  let baseCurrency: String
  
  var body: some View {
    Group {
      switch fetchState {
      case .fetching:
        Text("Fetching...")
      case .success:
        List {
          ForEach(fetchedCurrencies, id: \.symbol) { currency in
            Text(rate(for: currency))
          }
        }
      case .failed:
        Text("Fetch failed")
      }
    }
    .onAppear(perform: fetchData)
  }
  
  private func parse(result: CurrencyResult) {
    if result.rates.isEmpty {
      // fetch error
      fetchState = .failed
    } else {
      // fetch succeed
      fetchState = .success
      
      // read the user's selected currencies
      let selectedCurrencies = UserDefaults.standard.array(forKey: ContentView.selectedCurrenciesKey) as? [String] ?? ContentView.defaultCurrencies
      result.rates.forEach { symbol in
        // filter the rates so we only show ones the user selected
        guard selectedCurrencies.contains(symbol.key) else {
          return
        }
        
        let rateName = symbol.key
        let rateValue = symbol.value
        
        fetchedCurrencies.append((symbol: rateName, rate: rateValue))
      }
      
      fetchedCurrencies.sort { $0.symbol < $1.symbol }
    }
  }
  
  private func fetchData() {
    guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(Self.appID)&base=\(baseCurrency)") else {
      return
    }
    
    request = URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: CurrencyResult.self, decoder: JSONDecoder())
      .replaceError(with: CurrencyResult(base: "", rates: [:]))
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: parse)
  }
  
  private func rate(for currency: (symbol: String, rate: Double)) -> String {
    let value = currency.rate * amount
    let rate = String(format: "%.2f", value)
    return "\(currency.symbol) \(rate)"
  }
}

struct ResultView_Previews: PreviewProvider {
  static var previews: some View {
    ResultView(fetchState: .failed, amount: 500, baseCurrency: "USD")
    ResultView(fetchState: .success, amount: 500, baseCurrency: "USD")
    ResultView(fetchState: .fetching, amount: 500, baseCurrency: "USD")
  }
}

enum FetchState {
  case fetching, success, failed
}

struct CurrencyResult: Codable {
  let base: String
  let rates: [String: Double]
}
