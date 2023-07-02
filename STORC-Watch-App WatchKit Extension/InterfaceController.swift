//
//  InterfaceController.swift
//  STORC-Watch-App WatchKit Extension
//
//  Created by Brian H on 6/26/23.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("There was an error activating the session")
        }else{
            print("The session activated with a state of \(activationState)")
        }
    }
    
    
    var session = WCSession.default
    
    @IBOutlet weak var testOutput: WKInterfaceLabel!
    
    var healthStore : HKHealthStore?

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        self.getAuth()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func getAuth(){
        print("Trying to get health auth")
        //will ensure that health data is available
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }else{
            //no health data available not sure how to handle this
            print("Error health store is unavailable")
        }
        
        //Request read/write access to Heart Rate Data
        let dataTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore?.requestAuthorization(toShare: dataTypes, read: dataTypes) { success, error in
            //We got authorization
            if success{
                print("Health auth successfull")
                self.getHeartRateData()
            }else{
                //there was an error we can retry throw error or ask again?
                print("Error unable to get read and write access.")
            }
        }
    }
    
    func getHeartRateData(){
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        var a:String = ""
        
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            for sample in samples {
                a = String(format: ".2f%", sample.quantity.doubleValue(for: heartRateUnit))
                print(a)
            }
            
            DispatchQueue.main.async {
                self.testOutput.setText(a)
            }
        }
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .heartRate)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore?.execute(query)
    }
    
    func displayData(){
        
    }
    
    func sendMessage() {
        if session.isReachable {
            session.sendMessage(["message" : "Hello do you get this"], replyHandler: { (response) in
                print("Reply: \(response)")
            }, errorHandler: {(error) in
                print("Error sending message \(error)")
            })
        }else{
            print("iPhone is not reachable")
        }
    }
}
