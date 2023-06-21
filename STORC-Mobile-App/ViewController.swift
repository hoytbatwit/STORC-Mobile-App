//
//  ViewController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 6/9/23.
//

import UIKit
import HealthKit
import SwiftUI

class ViewController: UIViewController {

    //Working on timer stuff for manual contraction
    //var timerRunning = false
    //var ellapsedTime = 0
    // going to be used for contraction timing not implemented yet
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var buttonState = 0
    var healthStore : HKHealthStore?
    var HR = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //first we need to get authorization to use health kit data
    func getHealthAuth(){
        print("Trying to get health auth")
        //will ensure that health data is available
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }else{
            //no health data available not sure how to handle this
            //throw error?
            print("There was an error need a way to handle it")
        }
        
        //Request read/write access to Heart Rate Data
        let dataTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .restingHeartRate)!])
        healthStore?.requestAuthorization(toShare: dataTypes, read: dataTypes) { success, error in
            //We got authorization
            if success{
                print("Health auth successfull")
                self.getHeartRateData()
            }else{
                //there was an error we can retry throw error or ask again?
                print("Some error hopefully able to see in debug console.")
            }
        }
    }
    
    //next we actually get the health kit data that we need for the app
    func getHeartRateData(){
        print("trying to set up heart rate data")
        //type we are querying
        guard let heartRateOne = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            fatalError("This should never fail")
        }
        
        // setting up calendar for date range
        // I have a feeling this will be needed so going to write down the code for getting the current day
        /*
        let calendar = NSCalendar.current
        let new = Date()
        let componenets = calendar.dateComponents([.year, .month, .day], from: now)
        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create start date")
        }

        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create end date")
        }
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifiedStartDate, ascending: true)
        let filterQuery = HKSampleQuery(sampleType: heartRate, predicate: today, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortByDate]) {
            query, results, error in
        }
         */
        //var test = 0.0
        // query that is not filtered returns all results
        //let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        //let timeUnit:HKUnit = HKUnit(from: "min")
        let query = HKSampleQuery(sampleType: heartRateOne, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                //handle errors
                print("There was an error")
                return
            }
            
            for sample in samples {
                //process sample here
                print("\(sample)")
                //print("\(sample.startDate)")
                //test = sample.quantity.doubleValue(for: heartRateUnit)
                //print("Heart Rate: \(sample.quantity.doubleValue(for: heartRateUnit))")
                //print("Heart Rate: \(sample.quantity.doubleValue(for: timeUnit))")
            }
            
            //results come back on an anonymous background queue
            //dispatch to the main queue before modifying UI
            
        }
        healthStore?.execute(query)
    }
    
    //update UI with the health data that we got from the query
    func updateUI(){
        
    }
    
    func endContraction(peak: Int, current: Int) -> Bool {
        let percent = 100 * (current - peak) / (peak)
        print(percent)
        if percent >= 6 {
            return true
        }
        return false
    }
    
    func startContraction(current: Int, resting: Int) -> Bool {
        let percent = 100 * (current - resting) / resting
        if percent >= 6 {
            return true
        }
        return false
    }
    
    func findPeak(current: Int, start: Int) -> Bool {
        let percent = 100 * (start - current) / start
        if percent >= 9{
            return true
        }
        return false
    }
    
    //not going to write down generation of moving average yet cause need to figure out how HR data is looking
    //also not going to write down any main stuff yet cause not sure how that whole process is going to look
    @IBAction func manualButton(_ sender: UIButton) {
        switch buttonState{
        case 1:
            sender.setTitle("Tap here when the contraction ends", for: .normal)
            self.getHealthAuth()
            print("state is contraction is happening")
            buttonState = 0
        case 0:
            sender.setTitle("Tap here when a contraction begins", for: .normal)
            print("state is no contraction")
            buttonState = 1
        default:
            //sender.setTitle("Tap here when a contraction begins", for: .normal)
            //buttonState = 1
            return
        }
    }
}
