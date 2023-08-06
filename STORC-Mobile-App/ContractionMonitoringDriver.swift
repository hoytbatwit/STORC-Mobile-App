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

/**
 * This class contains functions and logic to combine the moving average contraction detection method and the ML  based contraction detection model.
 */
class ContractionMonitoringDriver {
    let movingAverageDetectionHandler = MovingAverageBasedContractionDetection()
    var context:NSManagedObjectContext!

    // Initializes the driver.
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext // Context for saving to CoreData
        
        let newHeartRateValueReceivedNotificationName = NSNotification.Name(rawValue:"NewHeartRateValueReceived")
        let contractionDetectionNotificationName = NSNotification.Name(rawValue:"ContractionOccurredNotification")
        
        // Will call monitorContraction each time a new heart rate is received.
        NotificationCenter.default.addObserver(self, selector: #selector(monitorContraction), name: newHeartRateValueReceivedNotificationName, object: nil)
        
        // Will call checkIfValidContraction when a contraction suspected notification is sent by the window based monitor.
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfValidContraction), name: contractionDetectionNotificationName, object: nil)
    }
    
    /**
     * Triggers the window based monitoring algorithm.
     *
     * @param notification The NSNotification object that contains the hear rate data points linked list, sent by the sender (or poster) of this notification.
     *
     */
    @objc private func monitorContraction(_ notification: NSNotification) {
        let heartRateDataPointList = notification.object as! LinkedList<HeartRateDataPoint>
        movingAverageDetectionHandler.monitor(heartRateValue: heartRateDataPointList, average: Int(generateMovingAverage(input: heartRateDataPointList)))
    }
    
    /**
     * Generates a moving average of the Heart Rate values present in the LinkedList.
     *
     * @param input The LinkedList of HeartRateDataPoints to generate the moving averages for.
     *
     * @returns A double with the moving average factored in for all HR values.
     *
     */
    public func generateMovingAverage(input: LinkedList<HeartRateDataPoint>) -> Double{
        var results = LinkedList<HeartRateDataPoint>()
        // LinkedList Implementation
        var size = Double(input.length)
        var sum = 0.0
        for currentHeartRateDataPoint in input {
            sum = sum + Double(currentHeartRateDataPoint.value.getHeartRateValue())
            // Add to LinkedList
            // Check Size and remove
            
            var newValue = sum / size
            var newData = HeartRateDataPoint(heartRateValue: Int(newValue), timeStamp: currentHeartRateDataPoint.value.getTimeStampValue())
            if(results.isEmpty == true){
                results.push(newData)
            }else{
                results.append(newData)
            }
            results.append(newData)
        }
        
        return sum/size
    }
    
    
    /**
     * Checks if a contraction is valid using the STORCTabularClassifier_Boosted_Tree ML Model. If valid, the contraction is saved to Core Data and the user is notified.
     *
     * @param notification The NSNotification object that contains the hear rate data points linked list, sent by the sender (or poster) of this notification.
     *
     */
    @objc private func checkIfValidContraction(_ notification: NSNotification) {
        let potentialContractionHeartRateDataPointLinkedList = notification.object as! LinkedList<HeartRateDataPoint>
        let accuracyThreshold = 0.75
        if(makePredictionBasedOnModel(heartRateDataPointsLinkedList: potentialContractionHeartRateDataPointLinkedList) > accuracyThreshold){
            print("Valid Contraction Occurred.")
            
            // Adds the confirmed contraction heart rate values to an array to allow for saving via core data.
            var heartRateValuesList = [Int]()
            
            let potentialContractionHeartRateDataPointList = convertLinkedListTo19MostRecent(heartRateDataPointLinkedList: potentialContractionHeartRateDataPointLinkedList)
            
            for heartRateDataPoint in potentialContractionHeartRateDataPointList {
                heartRateValuesList.append(heartRateDataPoint.getHeartRateValue())
            }
            
            // Save contraction.
            if(saveDataToCoreData(heartRateValueList: heartRateValuesList) == true){
                showContractionAlert()
                
                // Notifies the user that a contraction occured, sends a notification to the controller(s) of the relevant UI Pages, save contraction.
                let contractionConfirmedNotificationName = NSNotification.Name(rawValue:"ContractionConfirmedNotification")
                NotificationCenter.default.post(name: contractionConfirmedNotificationName, object: nil)
            }
        }
    }
    
    /**
     * Saves a contraction to Core Data.
     *
     * @param heartRateValueList The list of heart rate values to save to Core Data.
     *
     * @returns Bool Indicates whether or not the data was successfully saved to Core Data.
     *
     */
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
    
    // Shows an alert to the user notifying them that a contraction occurred.
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
    
    /**
     * This functinon checks 19 heart rate values at a time using the  STORCTabularClassifier_Boosted_Tree ML model for trends consistent with a contraction.
     *
     * @param heartRateDataPointsLinkedList The LinkedList of heart rate values that need to be checked.
     *
     * @returns Double A double from 0 to 1 representing the percentage chance that these values correspond to a contraction.
     *
     */
    private func makePredictionBasedOnModel(heartRateDataPointsLinkedList: LinkedList<HeartRateDataPoint>) -> Double {
        let heartRateDataPoints = convertLinkedListTo19MostRecent(heartRateDataPointLinkedList: heartRateDataPointsLinkedList)
        
        // Return if there are not enough heartRateDataPoints to make a prediction.
        if(heartRateDataPoints.count < 19){
            return 0
        }
        
        // Perform prediction and catch any errors.
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
    
    /**
     * Converts a LinkedList containing > 19 heart rate datapoints to a list containing the 19 most recent datapoints that can be used by the STORCTabularClassifier_Boosted_Tree ML model.
     *
     * @param heartRateDataPointsLinkedList The LinkedList of heart rate values that needs to be trimmed.
     *
     * @returns A list containing the 19 most recent heart rate datapoint values.
     *
     */
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
            // If there are less than 19 datapoints, a prediction cannot be perfomed so the original list is returned.
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
