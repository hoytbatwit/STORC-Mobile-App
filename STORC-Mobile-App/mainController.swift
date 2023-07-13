//
//  ViewController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 6/9/23.
//

import UIKit
import HealthKit
import SwiftUI
import WatchConnectivity

class mainController: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    //Working on timer stuff for manual contraction
    //var timerRunning = false
    //var ellapsedTime = 0
    // going to be used for contraction timing not implemented yet
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var list = LinkedList<Double>()
    var buttonState = 0
    var healthStore : HKHealthStore?
    var HR = 0.0
    let userInfo = UserDefaults.standard
    
    @IBOutlet weak var displayHR: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    //var HRValues: [Double] = []

    //@ObservedObject private var connectionManager = WatchConnection.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let name = userInfo.string(forKey: "Username")
        self.welcomeLabel.text = "Welcome " + name!
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
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
         */

    //Where we recieve the message from the watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let text = message["message"] as? String
        //add the value to an array for storage
        list.append(Double(text!)!)
        DispatchQueue.main.async {
            self.displayHR.text = text
        }
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
