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
    var HRData = LinkedList<HeartRateDatapoint>()
    var manualContractionTime = LinkedList<Int>()
    var monitor = ContractionMonitoringDriver()
    var buttonState = 0
    var currentLength = 0
    var timer = Timer()
    let userInfo = UserDefaults.standard
    
    @IBOutlet weak var displayHR: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var manualContractionLength: UILabel!
    @IBOutlet weak var HRTimeLabel: UILabel!
    
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
        ContractionDetection(input: self.HRData)
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
        let incomingDatapoint = message["message"] as? [Any]
        //let incomingDatapoint = message["message"] as? HeartRateDatapoint
        //let HR = incomingDatapoint?.getHeartRateValue()
        //let HRDate = incomingDatapoint?.getTimeStampValue()
        let HR = incomingDatapoint?[0]
        let HRDate = incomingDatapoint?[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        //print("\(HRTime!)")
        
        //need to differentiate between 1st and not 1st because if not some stuff wont work
        //also preserves the order that stuff was sent in
        if(HRData.isEmpty == true){
            HRData.push(HeartRateDatapoint(heartRateValue: HR! as! Double, timeStamp: HRDate! as! Date))
        }else{
            HRData.append(HeartRateDatapoint(heartRateValue: HR! as! Double, timeStamp: HRDate! as! Date))
        }
        DispatchQueue.main.async {
            self.displayHR.text = String(HR! as! Double)
            self.HRTimeLabel.text = dateFormatter.string(from: HRDate! as! Date)
        }
    }
    
    //what Im thinking for workflow of the detection process
    //all of this will be done in a seperate class but well notify users here by calling the notifyUsers function
    //1. set up monitor so that each time a new value is sent we check
    //2. if a contraction happened send back bool and the values we need
    //3. in main notify user we think contraction happened and save data
    //4. other stuff
    
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
    
    func ContractionDetection(input: LinkedList<HeartRateDatapoint>) {
        monitor
    }
    
    func notifyUserOfContraction(){
        let alert = UIAlertController(title: "Contraction Detected", message: "We detected a contraction. Please check the contraction log and let us know if we were correct.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: {_ in NSLog("The \"OK\" alert occured.")}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //generates the avereage HR for the HR values currently in the list
    func generateAverageHR(input: LinkedList<Double>) -> Double{
        let length = input.getLength()
        var temp = 0.0
        for HRValue in input{
            temp = temp + HRValue.value
        }
        return temp / Double(length)
    }
}
