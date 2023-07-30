//
//  ContractionMonitoringDriver.swift
//  STORC-Mobile-App
//
//  Created by Gabriel Baffo on 7/7/23.
//

import Foundation
import CoreML
import CoreData
import UIKit

class ContractionMonitoringDriver {
    
    let movingAverageDetectionHandler = MovingAverageBasedContractionDetection()
    var context:NSManagedObjectContext!

    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let newHeartRateValueReceivedNotificationName = NSNotification.Name(rawValue:"NewHeartRateValueReceived")
        let contractionDetectionNotificationName = NSNotification.Name(rawValue:"ContractionOccurredNotification")
        
        // Will call monitor contraction each time a new heart rate is received.
        NotificationCenter.default.addObserver(self, selector: #selector(monitorContraction), name: newHeartRateValueReceivedNotificationName, object: nil)
        
        // Will call check if valid contraction when a contraction suspected notification is sent by the window based monitor.
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfValidContraction), name: contractionDetectionNotificationName, object: nil)
    }
    
    @objc private func monitorContraction(_ notification: NSNotification) {
        print("Called monitor")
        let heartRateDataPointList = notification.object as! LinkedList<HeartRateDataPoint>
        print(heartRateDataPointList, " DP LIST DRIVER")
        movingAverageDetectionHandler.monitor(heartRateValue: heartRateDataPointList, average: 0)
    }
    
    @objc private func checkIfValidContraction(_ notification: NSNotification) {
        let potentialContractionHeartRateDataPointLinkedList = notification.object as! LinkedList<HeartRateDataPoint>
        let accuracyThreshold = 0.75
        if(makePredictionBasedOnModel(heartRateDataPointsLinkedList: potentialContractionHeartRateDataPointLinkedList) > accuracyThreshold){
            print("Valid Contraction Occurred.")
            
            // Add to list for saving via core data.
            var heartRateValuesList = [Int]()
            
            let potentialContractionHeartRateDataPointList = convertLinkedListTo19MostRecent(heartRateDataPointLinkedList: potentialContractionHeartRateDataPointLinkedList)
            
            for heartRateDataPoint in potentialContractionHeartRateDataPointList {
                heartRateValuesList.append(heartRateDataPoint.getHeartRateValue())
            }
            
            print(heartRateValuesList, "HRV Values list")
            // Save contraction.
            if(saveDataToCoreData(heartRateValueList: heartRateValuesList) == true){
                showContractionAlert()
            }
            
            // Notify user that a contraction occured, update relevant main pages, save contraction.
            // Removed code for push, not functional yet.
            
        }
    }
    
    func saveDataToCoreData(heartRateValueList: [Int]) -> Bool{
        print(heartRateValueList, " Saving this list")
        // Set of Doubles
        let setAsString: String = heartRateValueList.description
        //let setStringAsData = setAsString.data(using: String.Encoding.utf16)
                        
        let entity = NSEntityDescription.entity(forEntityName: "Contraction", in: context)
        let contraction = NSManagedObject(entity: entity!, insertInto: context)
        
        contraction.setValue(setAsString, forKey: "heartRateValues")
        contraction.setValue(Date.now, forKey: "timeOccurred")

        print("Storing Data..")
        do {
            try context.save()
            return true
        } catch {
            print("Storing data Failed")
            return false
        }

    }
    
    func showContractionAlert() {
        // create the alert
        let alert = UIAlertController(title: "Contraction Detected", message: "Please view your dashboard for more information.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        if #available(iOS 13.0, *) {
            if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Queue up 19 heart rate values, check and repeat. Can only accept 19 values currently.
    // Finish this function.
    private func makePredictionBasedOnModel(heartRateDataPointsLinkedList: LinkedList<HeartRateDataPoint>) -> Double {
        let heartRateDataPoints = convertLinkedListTo19MostRecent(heartRateDataPointLinkedList: heartRateDataPointsLinkedList)
        
        if(heartRateDataPoints.count < 19){
            print(heartRateDataPoints.count, "We are here")

            return 0
        }
        
        heartRateDataPoints.forEach({ heartRateDataPoint in
            print(heartRateDataPoint.getTimeStampValue())
        })
        
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
            return probabilitiesDictionary["C"] ?? 0
                
        } catch {
            fatalError("Failed to load ML model: \(error)")
        }
    }
    
    private func convertLinkedListTo19MostRecent(heartRateDataPointLinkedList: LinkedList<HeartRateDataPoint>) -> [HeartRateDataPoint]{
        var heartRateDataPointList = [HeartRateDataPoint]()
        for hrValue in heartRateDataPointLinkedList {
            heartRateDataPointList.append(hrValue.value)
        }
        print(heartRateDataPointLinkedList.length, " SIZE")
        heartRateDataPointList.reverse()
                
        if(heartRateDataPointList.count >= 19){
            var finalHeartRateDataPointList = [HeartRateDataPoint]()
            var count = 0
            while(count < 20){
                finalHeartRateDataPointList.append(heartRateDataPointList[count])
                count += 1
            }
            finalHeartRateDataPointList.reverse()
            return finalHeartRateDataPointList
        }else{
            heartRateDataPointList.reverse()
            var distanceTo19 = 19 - heartRateDataPointList.count // x amount of entries need to be added
            while(distanceTo19 != 0){
                heartRateDataPointList.append(heartRateDataPointList.last!)
                distanceTo19 -= 1
            }

            return heartRateDataPointList
        }
    }
}
