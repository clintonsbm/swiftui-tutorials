//
//  ContentView.swift
//  WeSplit
//
//  Created by Clinton Maciel on 13/07/20.
//  Copyright © 2020 Clinton. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: States
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = "2"
    @State private var tipPercentageIndex = 0
    
    // MARK: Control variables
    
    private let tipPercentages = [10, 15, 20, 25, 0]
    private var peopleCount: Double {
        Double(numberOfPeople) ?? 0 + 2
    }
    private var grandTotal: Double {
        let orderAmount = Double(checkAmount) ?? 0
        let tipSelection = Double(tipPercentages[tipPercentageIndex])
        
        let tipValue = (orderAmount / 100) * tipSelection
        let grandTotalValue = orderAmount + tipValue
        
        return grandTotalValue
    }
    private var totalPerPerson: Double {
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("How much tip?")) {
                    Picker("Tip percentage", selection: $tipPercentageIndex) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Number of people")) {
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Grand total")) {
                    Text("$\(grandTotal, specifier: "%.2f")")
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
