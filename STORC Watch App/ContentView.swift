//
//  ContentView.swift
//  STORC Watch App
//
//  Created by Gabriel Baffo on 7/26/23.
//

import SwiftUI
import HealthKit
import Foundation
import HealthKit
import WatchConnectivity
import WatchKit

struct ContentView: View {
    @State var heartRateText = Text("text")

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            heartRateText
        }.onAppear{
            getAuth { (true) in
                getHeartRateData { (true, heartRateValue) in
                    heartRateText = Text(heartRateValue + " HRV")
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

var backgroundHR = [Any]()
var healthStore : HKHealthStore?


func getAuth(completion: @escaping (Bool) -> ()){
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
            completion(true)
        }else{
            //there was an error we can retry throw error or ask again?
            print("Error unable to get read and write access.")
        }
    }
}

func getHeartRateData(completion: @escaping (Bool, String) -> ()){
    print("trying to get heart rate from the watch")
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    
    var dispayHR:String = ""
    var HRDate:Date = Date.now
    var HR:Double = 0.0
    //var temp:HeartRateDatapoint = HeartRateDatapoint(heartRateValue: HR, timeStamp: HRDate)
    var temp = [Any]()
    /*
    //so that sample comes from apple watch rather than from the healthstore
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
        print("\(results) Results")

        for sample in samples {
            //want to use this because passing in a whole date makes it easier for us to do other steps later
            HRDate = sample.endDate
            HR = sample.quantity.doubleValue(for: heartRateUnit)
            //temp = HeartRateDatapoint(heartRateValue: HR, timeStamp: HRDate)
            //self.backgroundHR.append(temp)
            temp.append(HR)
            temp.append(HRDate)
            //self.backgroundHR.append(temp)
            dispayHR = String(format: "%.2f%", HR)
            print(dispayHR + " DISPLAY HR")
            completion(true, dispayHR)
        }
    }
    healthStore?.execute(query)
    //return dispayHR
}
