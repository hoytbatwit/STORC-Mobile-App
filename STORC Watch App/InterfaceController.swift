////
////  InterfaceController.swift
////  STORC-Watch-App WatchKit Extension
////
////  Created by Brian H on 6/26/23.
////
//
//import WatchKit
//import Foundation
//import HealthKit
//import WatchConnectivity
//
//
//class InterfaceController: WKInterfaceController, WCSessionDelegate {
//    var backgroundHR = [Any]()
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//    }
//
//
//    @IBOutlet weak var testOutput: WKInterfaceLabel!
//
//    var healthStore : HKHealthStore?
//
//    override func awake(withContext context: Any?) {
//        // Configure interface objects here.
//    }
//
//    override func willActivate() {
//        // This method is called when watch view controller is about to be visible to user
//        if(WCSession.isSupported()){
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//        self.getAuth()
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//    }
//
//}
