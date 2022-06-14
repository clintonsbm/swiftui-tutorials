//
//  ResultView.swift
//  Project4 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 13/06/22.
//

import SwiftUI

struct ResultView: View {
  let amount: Double
  let currency: String
  
  var body: some View {
    Text("\(amount) and \(currency)")
  }
}

struct ResultView_Previews: PreviewProvider {
  static var previews: some View {
    ResultView(amount: 100, currency: "USD")
  }
}
