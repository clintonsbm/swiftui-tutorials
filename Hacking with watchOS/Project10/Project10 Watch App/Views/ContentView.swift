//
//  ContentView.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    // MARK: Models
    
    struct Activity: Identifiable {
        let id = UUID()
        let name: String
        let type: HKWorkoutActivityType
    }
    
    // MARK: States
    
    @StateObject var workoutManager = WorkoutManager.shared
    
    // MARK: Propreties
    
    private let activities: [Activity] = [
        Activity(name: "Cycling", type: .cycling),
        Activity(name: "Running", type: .running),
        Activity(name: "Wheelchair", type: .wheelchairRunPace)
    ]
    
    var body: some View {
        switch workoutManager.state {
        case .active, .paused:
            WorkoutView(workoutManager: workoutManager)
        case .inactive:
            VStack {
                Text("Select a activity")
                
                List(activities) { activity in
                    Text(activity.name)
                        .onTapGesture {
                            guard HKHealthStore.isHealthDataAvailable() else { return }
                            workoutManager.set(activity: activity.type)
                            workoutManager.beginWorkout()
                        }
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
