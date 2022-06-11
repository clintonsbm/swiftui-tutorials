//
//  ContentView.swift
//  Project2 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 11/06/22.
//

import SwiftUI

struct ContentView: View {
  // Level
  @State private var question = "rock"
  @State private var title = "Win!"
  @State private var shouldWin = true
  @State private var level = 1
  @State private var moves = ["rock", "paper", "scissors"]
  @State var gameOver = false
  
  // Timer
  @State private var currentTime = Date()
  @State private var startTime = Date()
  let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
  var time: String {
    let difference = currentTime.timeIntervalSince(startTime)
    return String(Int(difference))
  }
  
  let solutions = [
     "rock": (win: "paper", lose: "scissors"),
     "paper": (win: "scissors", lose: "rock"),
     "scissors": (win: "rock", lose: "paper")
  ]
  
  var body: some View {
    VStack {
      if gameOver {
        List {
          Text("You win!")
            .font(.largeTitle)
          Text("Your time was: \(time)s")
          
          Button("Play Again") {
            startTime = Date()
            gameOver = false
            level = 1
            newLevel()
          }
          .buttonStyle(BorderedButtonStyle(tint: .green))
        }
      } else {
        Image(question)
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .tint(.white)
        
        Divider()
          .padding()
        
        HStack {
          ForEach(moves, id: \.self) { type in
            Button {
              select(move: type)
            } label: {
              Image(type)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .tint(.white)
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        
        HStack {
          Text("\(level)/20")
          Spacer()
          Text("Time: \(time)")
        }
        .padding([.top, .horizontal])
      }
    }
    .navigationTitle(title)
    .onAppear(perform: newLevel)
    .onReceive(timer) { newTime in
      guard !gameOver else { return }
      currentTime = newTime
    }
  }
  
  private func select(move: String) {
    guard let answer = solutions[question] else {
      fatalError("Unknown question: \(question)")
    }
    
    let isCorrect: Bool
    
    if shouldWin {
      isCorrect = move == answer.win
    } else {
      isCorrect = move == answer.lose
    }
    
    if isCorrect {
      level += 1
    } else {
      level -= 1
      level = level < 1 ? 1 : level
    }
    
    newLevel()
  }
  
  private func newLevel() {
    if level == 21 {
      gameOver = true
      return
    }
    moves = moves.shuffled()
    
    let randomShouldWin = Bool.random()
    title = randomShouldWin ? "Win!" : "Lose!"
    shouldWin = randomShouldWin
    
    var newQuestion = moves.randomElement()!
    while newQuestion == question {
      newQuestion = moves.randomElement()!
    }
    question = newQuestion
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewDisplayName("Initial State")
    
    ContentView(gameOver: true)
      .previewDisplayName("End game")
  }
}
