//
//  ContractionMonitoringDriver.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/23/23.
//

import Foundation
import CoreML

class ContractionMonitoringDriver {
    let newHeartRateValueReceivedNotificationName = Notification.Name("NewHeartRateValueReceived")
    let contractionDetectionNotificationName = Notification.Name("ContractionOccurredNotification")
    let movingAverageDetectionHandler = MovingAverageBasedContractionDetection()
    let heartRateDataPointList = LinkedList<HeartRateDatapoint>()
    let potentialContractionHeartRateDataPointList = LinkedList<HeartRateDatapoint>()
    
    init() {
        // Will call monitor contraction each time a new heart rate is received.
        NotificationCenter.default.addObserver(self, selector: #selector(monitorContraction), name: newHeartRateValueReceivedNotificationName, object: heartRateDataPointList)
        
        // Will call check if valid contraction when a contraction suspected notification is sent by the window based monitor.
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfValidContraction), name: contractionDetectionNotificationName, object: potentialContractionHeartRateDataPointList)
    }
    
    @objc private func monitorContraction() {
        movingAverageDetectionHandler.monitor(heartRateValue: heartRateDataPointList, average: 0)
    }
    
    @objc private func checkIfValidContraction() {
        let accuracyThreshold = 0.75
        if(makePredictionBasedOnModel(heartRateDataPoints: potentialContractionHeartRateDataPointList) > accuracyThreshold){
            print("Valid Contraction Occurred.")
            // Save contraction.
            // Notify user that a contraction occured, update relevant main pages, save contraction.
            // Removed code for push, not functional yet.
        }
    }

    // Queue up 19 heart rate values, check and repeat. Can only accept 19 values currently.
    // Finish this function.
    private func makePredictionBasedOnModel(heartRateDataPoints: LinkedList<HeartRateDatapoint>) -> Double {
        do {
            let model = try STORCTabularClassifier_Boosted_Tree(configuration: MLModelConfiguration())
            let prediction = try model.prediction(
                HR_0_00: Double((heartRateDataPoints.getNodeAt(at: 0)?.value.getHeartRateValue())!),
                HR___0_05: Double((heartRateDataPoints.getNodeAt(at: 1)?.value.getHeartRateValue())!),
                HR___0_10: Double((heartRateDataPoints.getNodeAt(at: 2)?.value.getHeartRateValue())!),
                HR___0_15: Double((heartRateDataPoints.getNodeAt(at: 3)?.value.getHeartRateValue())!),
                HR___0_20: Double((heartRateDataPoints.getNodeAt(at: 4)?.value.getHeartRateValue())!),
                HR___0_25: Double((heartRateDataPoints.getNodeAt(at: 5)?.value.getHeartRateValue())!),
                HR___0_30: Double((heartRateDataPoints.getNodeAt(at: 6)?.value.getHeartRateValue())!),
                HR___0_35: Double((heartRateDataPoints.getNodeAt(at: 7)?.value.getHeartRateValue())!),
                HR___0_40: Double((heartRateDataPoints.getNodeAt(at: 8)?.value.getHeartRateValue())!),
                HR___0_45: Double((heartRateDataPoints.getNodeAt(at: 9)?.value.getHeartRateValue())!),
                HR___0_50: Double((heartRateDataPoints.getNodeAt(at: 10)?.value.getHeartRateValue())!),
                HR___0_55: Double((heartRateDataPoints.getNodeAt(at: 11)?.value.getHeartRateValue())!),
                HR___1_0: Double((heartRateDataPoints.getNodeAt(at: 12)?.value.getHeartRateValue())!),
                HR_1_05: Double((heartRateDataPoints.getNodeAt(at: 13)?.value.getHeartRateValue())!),
                HR___1_10: Double((heartRateDataPoints.getNodeAt(at: 14)?.value.getHeartRateValue())!),
                HR___1_15: Double((heartRateDataPoints.getNodeAt(at: 15)?.value.getHeartRateValue())!),
                HR___1_20: Double((heartRateDataPoints.getNodeAt(at: 16)?.value.getHeartRateValue())!),
                HR___1_25: Double((heartRateDataPoints.getNodeAt(at: 17)?.value.getHeartRateValue())!),
                HR___1_30: Double((heartRateDataPoints.getNodeAt(at: 18)?.value.getHeartRateValue())!))
            
            let probabilitiesDictionary = prediction.StateProbability
            
            print(probabilitiesDictionary)
                
        } catch {
            fatalError("Failed to load ML model: \(error)")
        }
        
        return 0
    }
}
