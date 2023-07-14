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
import Foundation

class mainController: UIViewController, WCSessionDelegate {
    var watchHR = LinkedList<Double>()
    var manualContractionTime = LinkedList<Int>()
    var buttonState = 0
    var currentLength = 0
    var timer = Timer()
    let userInfo = UserDefaults.standard
    
    @IBOutlet weak var displayHR: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var manualContractionLength: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = userInfo.string(forKey: "Username")
        self.welcomeLabel.text = "Welcome " + name!
        self.manualContractionLength.text = "No contraction happening right now"
        
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
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    //Where we recieve the message from the watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let text = message["message"] as? String
        watchHR.append(Double(text!)!)
        DispatchQueue.main.async {
            self.displayHR.text = text
        }
    }
    
    //logic for manual contraction detection if the user wants to use this instead
    @IBAction func manualButton(_ sender: UIButton) {
        switch buttonState{
        case 1:
            sender.setTitle("Tap here when a contraction begins", for: .normal)
            timer.invalidate()
            manualContractionLength.text = "No contraction happening right now."
            manualContractionTime.append(currentLength)
            currentLength = 0
            buttonState = 0
        case 0:
            sender.setTitle("Tap here when the contraction ends", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(timerAction)), userInfo: nil, repeats: true)
            buttonState = 1
        default:
            sender.setTitle("Tap here when a contractoin begins", for: .normal)
            return
        }
    }
    
    @objc func timerAction() {
        currentLength = currentLength + 1
        manualContractionLength.text = "Current Length of your contraction: \(currentLength) seconds"
    }
}
