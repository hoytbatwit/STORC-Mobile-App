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
    
    func getHealth(){
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }else{
            //no health data available not sure how to handle this
            //throw error?
        }
        
        //Request read/write access to Heart Rate Data
        let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 24, minute: 0, second: 0, of: Date())!
        //let hrQuantity = HKQuantity(
        //let read:Set = Set([heartRateType])
        let write:Set = Set([heartRateType])
        
        healthStore?.requestAuthorization(toShare: write, read: nil) { success, error in
            if success{
                //Successful request save sample here
                //let sample = HKQuantitySample(type: heartRateType, )
            }else{
                //failure can retry
            }
        }
    }
    
    
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
}

