//
//  ContentView.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    // MARK: States
    
    @StateObject var workoutManager = WorkoutManager.shared
    @State private var selectedActivity = 0
    
    // MARK: Propreties
    
    private let activities: [(name: String, type: HKWorkoutActivityType)] = [
        ("Cycling", .cycling),
        ("Running", .running),
        ("Wheelchair", .wheelchairRunPace)
    ]
    
    var body: some View {
        switch workoutManager.state {
        case .active, .paused:
            WorkoutView()
        case .inactive:
            VStack {
                Picker("Choose an activity", selection: $selectedActivity) {
                    ForEach(0..<activities.count, id: \.self) { index in
                        Text(activities[index].name)
                    }
                }
                
                Button("Start Workout") {
                    guard HKHealthStore.isHealthDataAvailable() else { return }
                    workoutManager.set(activity: activities[selectedActivity].type)
                    workoutManager.beginWorkout()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
