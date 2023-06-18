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
    var timerRunning = false
    var ellapsedTime = 0
    var buttonState = 0
    @IBOutlet weak var heartRate: UILabel!
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var healthStore : HKHealthStore?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //first we need to get authorization to use health kit data
    func getHealthAuth(){
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }else{
            //no health data available not sure how to handle this
            //throw error?
        }
        
        //Request read/write access to Heart Rate Data
        let dataTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .restingHeartRate)!])
        
        healthStore?.requestAuthorization(toShare: dataTypes, read: dataTypes) { success, error in
            if success{
                //We got authorization
                self.getHeartRateData()
            }else{
                //there was an error we can retry throw error or ask again?
                self.getHealthAuth()
            }
        }
    }
    
    //next we actually get the health kit data that we need for the app
    func getHeartRateData(){
        //type we are querying
        let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
        //setting up calendar for date range
        let calendar = Calendar(identifier: .gregorian)
        //March 18th 2017 is when sample data was taken
        var dateComponents = DateComponents()
        dateComponents.year = 2017
        dateComponents.month = 3
        dateComponents.day = 18
        
        let startDate = calendar.date(from: dateComponents)
        let endDate = calendar.date(from: dateComponents)
        let pred = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sort = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let query = HKSampleQuery(sampleType: heartRate, predicate: pred, limit: 25, sortDescriptors: sort, resultsHandler: { (query, results,error) in
            guard error == nil else { print("error"); return }
        
            self.printHeartRateInfo(results: results)
        })
        
        healthStore?.execute(query)
        
    }
    
    func printHeartRateInfo(results:[HKSample]?){
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        for(_, sample) in results!.enumerated(){
            guard let currData:HKQuantitySample = sample as? HKQuantitySample else {return}
            
            print("\(sample)")
            print("Heart Rate: \(currData.quantity.doubleValue(for: heartRateUnit))")
        }
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
            buttonState = 0
        case 0:
            sender.setTitle("Tap here when a contraction begins", for: .normal)
            buttonState = 1
        default:
            sender.setTitle("Tap here when a contraction begins", for: .normal)
        }
        if(buttonState == 1){
            
        }
    }
    
    //button just for testing methods I think I can call them from here
    @IBAction func testingButton(_ sender: UIButton) {
        
    }
    
}
