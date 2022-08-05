//
//  SessionHandler.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import Foundation
import HealthKit

class SessionHandler: NSObject, HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        //
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        //
    }
}
