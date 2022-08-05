//
//  DataManager.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import Foundation
import HealthKit

class WorkoutManager {
    enum WorkoutState {
        case inactive, active, paused
    }
    
    // MARK: Static
    
    static let shared = WorkoutManager()
    
    // MARK: Propreties
    
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private let sessionHandler = SessionHandler()
    private let builderHandler = BuilderHandler()
    
    private var activity = HKWorkoutActivityType.cycling
    private(set) var state = WorkoutState.inactive
    
    // MARK: Methods
    
    func beginWorkout() {
        let sampleTypes: Set<HKSampleType> = [
            .workoutType(),
            .quantityType(forIdentifier: .heartRate)!,
            .quantityType(forIdentifier: .activeEnergyBurned)!,
            .quantityType(forIdentifier: .distanceCycling)!,
            .quantityType(forIdentifier: .distanceWalkingRunning)!,
            .quantityType(forIdentifier: .distanceWheelchair)!
        ]
        
        healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes) { succeeded, error in
            guard succeeded else { return }
            self.createWorkout()
        }
    }
    
    private func createWorkout() {
        let config = HKWorkoutConfiguration()
        config.activityType = activity
        config.locationType = .indoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        } catch {
            print(error)
            return
        }
        
        workoutBuilder = workoutSession?.associatedWorkoutBuilder()
        workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
        workoutSession?.delegate = sessionHandler
        workoutBuilder?.delegate = builderHandler
        workoutSession?.startActivity(with: .now)
        workoutBuilder?.beginCollection(withStart: .now, completion: { succeeded, error in
            guard succeeded else { return }
            
            DispatchQueue.main.async {
                self.state = .active
            }
        })
    }
    
    func set(activity: HKWorkoutActivityType) {
        self.activity = activity
    }
}

// MARK: ObservableObject

extension WorkoutManager: ObservableObject {
    
}
