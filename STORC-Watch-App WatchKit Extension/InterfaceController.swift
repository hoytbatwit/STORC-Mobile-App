//
//  InterfaceController.swift
//  STORC-Watch-App WatchKit Extension
//
//  Created by Brian H on 6/26/23.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {
    
    var healthStore : HKHealthStore?

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        self.getAuth()
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
        //let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            //This is how they process the sample and make is displayable to the user
            //self.process(samples, type: HKQuantityTypeIdentifier)
        }
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .heartRate)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore?.execute(query)
    }
}
