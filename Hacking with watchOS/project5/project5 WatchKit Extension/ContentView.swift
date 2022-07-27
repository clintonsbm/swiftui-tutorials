//
//  ContentView.swift
//  project5 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 18/06/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
  private let colors = [
    "Red": Color(red: 1, green: 0, blue: 0),
    "Green": Color(red: 0, green: 0.5, blue: 0),
    "Blue": Color(red: 0, green: 0, blue: 1),
    "Orange": Color(red: 1, green: 0.6, blue: 0),
    "Purple": Color(red: 0.5, green: 0, blue: 0.5),
    "Black": Color.black
  ]
  private let maxLevel = 10
  
  @State private var colorKeys = ["Red", "Green", "Blue","Orange", "Purple", "Black"]
  @State private var correctAnswer = 0
  @State private var currentLevel = 0
  @State private var gameOver = false
  @State private var title = ""
  @State private var startTime = Date()
  
  var body: some View {
    VStack(spacing: 10) {
      HStack(spacing: 10) {
        text(for: 0)
        text(for: 1)
      }
      
      HStack(spacing: 10) {
        text(for: 2)
        text(for: 3)
      }
    }
    .navigationTitle(title)
    .onAppear(perform: startNewGame)
    .sheet(isPresented: $gameOver) {
      Text("You win!")
      Text("You finished in \(Int(Date().timeIntervalSince(startTime)))")
      Button("Play again", action: startNewGame)
    }
  }
  
  private func text(for index: Int) -> some View {
    let title = index == correctAnswer ? colorKeys[colorKeys.count - 1] : colorKeys[index]
    
    return Text(title)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(colors[colorKeys[index]])
      .cornerRadius(20)
      .onTapGesture {
        tapped(index)
      }
  }
  
  private func createLevel() {
    guard currentLevel < maxLevel else {
      gameOver = true
      return
    }
    
    title = "Level \(currentLevel)/\(maxLevel)"
    correctAnswer = Int.random(in: 0...3)
    colorKeys.shuffle()
  }
  
  private func startNewGame() {
    startTime = Date()
    currentLevel = 1
    gameOver = false
    createLevel()
    
    setPlayReminder()
  }
  
  private func tapped(_ index: Int) {
    if index == correctAnswer {
      currentLevel += 1
    } else {
      currentLevel -= 1
      currentLevel = max(1, currentLevel)
    }
    
    createLevel()
  }
  
  private func createNotification() {
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = "We miss you!"
    content.body = "Come back and play the game more!"
    content.sound = .default
    content.categoryIdentifier = "play_reminder"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    center.add(request)
  }
  
  private func setPlayReminder() {
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .sound]) { success, error in
      guard success else {
        return
      }
      
      center.removeAllPendingNotificationRequests()
      registerCategories()
      createNotification()
    }
  }
  
  private func registerCategories() {
    let center = UNUserNotificationCenter.current()
    
    let play = UNNotificationAction(identifier: "play", title: "Play Now", options: .foreground)
    
    let category = UNNotificationCategory(identifier: "play_reminder", actions: [play], intentIdentifiers: [])
    
    center.setNotificationCategories([category])
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
