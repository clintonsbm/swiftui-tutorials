//
//  ContentView.swift
//  Project8 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 02/08/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: States
    
    @State private var gameOver = false
    
    @State private var currentSafeValue = 50.0
    @State private var targetSafeValue = 0
    @State private var correctValues = [String]()
    @State private var allSafeNumbers = [Int]()
    
    @State private var title = "Safe Crack"
    
    @State private var currentTime = Date()
    @State private var startTime = Date()
    
    // MARK: Propreties
    
    private let numberOfRounds = 3
    
    private let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    private var answerIsCorrect: Bool {
        Int(currentSafeValue) == targetSafeValue
    }
    
    private var answerColor: Color {
        answerIsCorrect ? .green : .red
    }
    
    private var time: String {
        let difference = currentTime.timeIntervalSince(startTime)
        return String(Int(difference))
    }
    
    // MARK: Body
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            
            Slider(value: $currentSafeValue, in: 1...1000, step: 1)
            
            Button("Enter \(Int(currentSafeValue))", action: nextTapped)
            
            Text("Time \(time)")
        }
        .onReceive(timer) { newTime in
            guard !gameOver else { return }
            currentTime = newTime
        }.alert(isPresented: $gameOver) {
            Alert(title: Text("You win!"), message: Text("Finished in \(time) seconds"), dismissButton: .default(Text("Play Again"), action: startNewGame))
        }.onAppear(perform: startNewGame)
    }
    
    private func nextTapped() {
        guard answerIsCorrect else {
            showTip()
            return
        }
        
        correctValues.append(String(Int(currentSafeValue)))
        title = correctValues.joined(separator: ", ")
        
        if correctValues.count >= numberOfRounds {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                gameOver = true
            }
        } else {
            pickNumber()
        }
    }
    
    private func startNewGame() {
        startTime = Date()
        
        allSafeNumbers = Array(1...100)
        allSafeNumbers.shuffle()
        
        currentSafeValue = 50
        
        correctValues.removeAll()
        
        pickNumber()
    }
    
    private func pickNumber() {
        targetSafeValue = allSafeNumbers.removeFirst()
    }
    
    private func showTip() {
        title = Int(currentSafeValue) < targetSafeValue ? "Greater" : "Lower"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
