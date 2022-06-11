//
//  CreditsView.swift
//  Project1 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 11/06/22.
//

import SwiftUI

struct CreditsView: View {
  var body: some View {
    HStack {
      Image(systemName: "person.fill")
      Text("Clinton Barreto")
    }
  }
}

struct CreditsView_Previews: PreviewProvider {
  static var previews: some View {
    CreditsView()
  }
}
