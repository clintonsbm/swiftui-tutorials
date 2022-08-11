//
//  WorkoutView.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    
    // MARK: Models
    
    enum DisplayMode {
        case distance, energy, heartRate
    }
    
    // MARK: Properties
    
    @ObservedObject var workoutManager: WorkoutManager
    
    /// Value to be displayed
    private var quantity: String {
        switch displayMode {
        case .distance:
            let km = workoutManager.totalDistance / 1_000
            return String(format: "%.2f", km)
        case .energy:
            return String(format: "%.2f", workoutManager.totalEnergyBurned)
        case .heartRate:
            return String(Int(workoutManager.lastHeartRate))
        }
    }
    
    /// Unity of the value being displayed
    private var unity: String {
        switch displayMode {
        case .distance:
            return "Km"
        case .energy:
            return "calories"
        case .heartRate:
            return "beats / min"
        }
    }
    
    // MARK: States
    
    @State private var displayMode = DisplayMode.distance
    @State private var showAlert = false
    
    // MARK: Body
    
    var body: some View {
        VStack {
            Group {
                Text(quantity)
                    .font(.largeTitle)
                Text(unity)
                    .textCase(.uppercase)
            }
            .onTapGesture(perform: changeDisplayMode)
            .alert("Alert", isPresented: $showAlert) {
                Button("Save") {
                    workoutManager.end(shouldSave: true)
                }
                Button("Discard", role: .destructive) {
                    workoutManager.end(shouldSave: false)
                }
            }
            
            switch workoutManager.state {
            case .active:
                Button("Pause", action: workoutManager.pause)
            default:
                Button("Resume", action: workoutManager.resume)
                Button("End", role: .destructive) {
                    showAlert = true
                }
                    
            }
        }
    }
    
    // MARK: Methods
    
    private func changeDisplayMode() {
        switch displayMode {
        case .distance:
            displayMode = .energy
        case .energy:
            displayMode = .heartRate
        case .heartRate:
            displayMode = .distance
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workoutManager: .init())
    }
}
