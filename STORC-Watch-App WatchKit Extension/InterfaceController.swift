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
    }
    
    
    @IBOutlet weak var testOutput: WKInterfaceLabel!
    
    var healthStore : HKHealthStore?

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        self.getAuth()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func getAuth(){
        //will ensure that health data is available
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }else{
            //no health data available
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
        print("trying to get heart rate from the watch")
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        var a:String = ""
        /*
        
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
        */
        //previously used HKAnchoredObjectQuery
        let query = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { query, results, error in
            
            guard let samples = results as?
                    [HKQuantitySample] else {
                print("There was an error")
                return
            }
            
            for sample in samples {
                a = String(format: "%.2f%", sample.quantity.doubleValue(for: heartRateUnit))
            }
            
            DispatchQueue.main.async {
                self.testOutput.setText(a)
                self.testOutput.setTextColor(UIColor.white)
                WCSession.default.sendMessage(["message": a], replyHandler: nil) { error in
                    print("Cannot send message: \(error)")
                }
            }
        }
        healthStore?.execute(query)
    }
}