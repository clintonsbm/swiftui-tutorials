//
//  File.swift
//  Project10 Watch App
//
//  Created by Clinton de Sá Barreto Maciel on 04/08/22.
//

import Foundation
import HealthKit

class BuilderHandler: NSObject, HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        //
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        //
    }
}
