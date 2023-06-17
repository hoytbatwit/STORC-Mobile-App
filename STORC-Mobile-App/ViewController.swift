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
            }
        }
    }
    
    //next we actually get the health kit data that we need for the app
    func getHeartRateData(){
        let restingType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        //only want todays resting HR
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 24, minute: 0, second: 0, of: Date())!
        
        let hrUnit = HKQuantity(unit: HKUnit.count(), doubleValue: 70.0)
        let sample = HKQuantitySample(type: restingType, quantity: hrUnit, start: startDate, end: endDate)
        healthStore?.save(sample) {success, error in
            if success {
                //we got sample and can pass it to UI updater method
                //need some kind of data to pass into UI function though gonna have to look into that
                self.updateUI()
            }else{
                //there was an error throw error or interupt program somehow?
            }
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
