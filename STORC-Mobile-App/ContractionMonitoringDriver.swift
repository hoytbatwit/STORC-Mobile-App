//
//  ContractionMonitoringDriver.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/7/23.
//

import Foundation
import CoreML

class ContractionMonitoringDriver {
    
    let movingAverageDetectionHandler = MovingAverageBasedContractionDetection()
    
    init() {
        
        let newHeartRateValueReceivedNotificationName = NSNotification.Name(rawValue:"NewHeartRateValueReceived")
        let contractionDetectionNotificationName = NSNotification.Name(rawValue:"ContractionOccurredNotification")
        
        // Will call monitor contraction each time a new heart rate is received.
        NotificationCenter.default.addObserver(self, selector: #selector(monitorContraction), name: newHeartRateValueReceivedNotificationName, object: nil)
        
        // Will call check if valid contraction when a contraction suspected notification is sent by the window based monitor.
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfValidContraction), name: contractionDetectionNotificationName, object: nil)
    }
    
    @objc private func monitorContraction(_ notification: NSNotification) {
        print("Called monitor")
        let heartRateDataPointList = notification.object as! [HeartRateDataPoint]
        movingAverageDetectionHandler.monitor(heartRateValues: heartRateDataPointList, average: 0)
    }
    
    @objc private func checkIfValidContraction(_ notification: NSNotification) {
        let potentialContractionHeartRateDataPointList = notification.object as! [HeartRateDataPoint]
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
    private func makePredictionBasedOnModel(heartRateDataPoints: [HeartRateDataPoint]) -> Double {
        do {
            let model = try STORCTabularClassifier_Boosted_Tree(configuration: MLModelConfiguration())
            let prediction = try model.prediction(
                HR_0_00: Double(heartRateDataPoints[0].getHeartRateValue()),
                HR___0_05: Double(heartRateDataPoints[1].getHeartRateValue()),
                HR___0_10: Double(heartRateDataPoints[2].getHeartRateValue()),
                HR___0_15: Double(heartRateDataPoints[3].getHeartRateValue()),
                HR___0_20: Double(heartRateDataPoints[4].getHeartRateValue()),
                HR___0_25: Double(heartRateDataPoints[5].getHeartRateValue()),
                HR___0_30: Double(heartRateDataPoints[6].getHeartRateValue()),
                HR___0_35: Double(heartRateDataPoints[7].getHeartRateValue()),
                HR___0_40: Double(heartRateDataPoints[8].getHeartRateValue()),
                HR___0_45: Double(heartRateDataPoints[9].getHeartRateValue()),
                HR___0_50: Double(heartRateDataPoints[10].getHeartRateValue()),
                HR___0_55: Double(heartRateDataPoints[11].getHeartRateValue()),
                HR___1_0: Double(heartRateDataPoints[12].getHeartRateValue()),
                HR_1_05: Double(heartRateDataPoints[13].getHeartRateValue()),
                HR___1_10: Double(heartRateDataPoints[14].getHeartRateValue()),
                HR___1_15: Double(heartRateDataPoints[15].getHeartRateValue()),
                HR___1_20: Double(heartRateDataPoints[16].getHeartRateValue()),
                HR___1_25: Double(heartRateDataPoints[17].getHeartRateValue()),
                HR___1_30: Double(heartRateDataPoints[18].getHeartRateValue()))
            
            let probabilitiesDictionary = prediction.StateProbability
            
            print(probabilitiesDictionary)
                
        } catch {
            fatalError("Failed to load ML model: \(error)")
        }
        
        return 0
    }
}
