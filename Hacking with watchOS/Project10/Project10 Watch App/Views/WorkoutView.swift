//
//  WorkoutView.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    
    // MARK: States
    
    @State private var selectedActivity = 0
    
    // MARK: Propreties
    
    private let activities: [(name: String, type: HKWorkoutActivityType)] = [
        ("Cycling", .cycling),
        ("Running", .running),
        ("Wheelchair", .wheelchairRunPace)
    ]
    
    // MARK: Body
    
    var body: some View {
        VStack {
            Picker("Choose an activity", selection: $selectedActivity) {
                ForEach(0..<activities.count, id: \.self) { index in
                    Text(activities[index].name)
                }
            }
            
            Button("Start Workout") {
                guard HKHealthStore.isHealthDataAvailable() else { return }
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
