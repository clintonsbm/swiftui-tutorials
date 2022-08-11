//
//  DataManager.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import Foundation
import HealthKit
import SwiftUI

class WorkoutManager: NSObject {
    enum WorkoutState {
        case inactive, active, paused
    }
    
    // MARK: Static
    
    static let shared = WorkoutManager()
    
    // MARK: Propreties
    
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    
    private var activity = HKWorkoutActivityType.cycling
    
    // MARK: Observables
    
    @Published private(set) var state = WorkoutState.inactive
    @Published private(set) var lastHeartRate = 0.0
    @Published private(set) var totalEnergyBurned = 0.0
    @Published private(set) var totalDistance = 0.0
    
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
        config.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        } catch {
            print(error)
            return
        }
        
        workoutBuilder = workoutSession?.associatedWorkoutBuilder()
        workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
        workoutSession?.delegate = self
        workoutBuilder?.delegate = self
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
    
    private func save() {
        workoutBuilder?.endCollection(withEnd: .now, completion: { success, error in
            self.workoutBuilder?.finishWorkout(completion: { workout, workoutError in
                DispatchQueue.main.async {
                    self.state = .inactive
                }
            })
        })
    }
    
    // MARK: Managing Workout Status
    
    func pause() {
        workoutSession?.pause()
    }
    
    func resume() {
        workoutSession?.resume()
    }
    
    func end(shouldSave: Bool) {
        workoutSession?.end()
        guard shouldSave else { return }
        save()
    }
}

// MARK: ObservableObject

extension WorkoutManager: ObservableObject {}

// MARK: HKWorkoutSessionDelegate

extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.state = .active
            case .ended:
                self.state = .inactive
            case .paused:
                self.state = .paused
            default:
                break
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //
    }
}

// MARK: HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        collectedTypes.forEach { sample in
            guard let quantityType = sample as? HKQuantityType else { return }
            guard let statistics = workoutBuilder.statistics(for: quantityType) else { return }
            
            DispatchQueue.main.async {
                switch statistics.quantityType {
                case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                    let value = statistics.sumQuantity()?.doubleValue(for: .smallCalorie()) ?? 0
                    self.totalEnergyBurned = value
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                    self.lastHeartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                default:
                    let value = statistics.sumQuantity()?.doubleValue(for: .meter()) ?? 0
                    self.totalDistance = value
                }
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //
    }
}
