//
//  InterfaceController.swift
//  STORC-Watch-App WatchKit Extension
//
//  Created by Brian H on 6/26/23.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity


class ContentViewModel: NSObject, WCSessionDelegate {
    var backgroundHR = [Any]()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activated? ", activationState, " ", session)
    }

    @IBOutlet weak var testOutput: WKInterfaceLabel!

    var healthStore : HKHealthStore?

    init(session: WCSession = .default){
        super.init()
        
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendMessage(message: [Any]){
        while(WCSession.default.activationState != .activated){
            print("looping")
//            if(WCSession.default.activationState == .activated){
//                WCSession.default.activate()
//            }
            continue
        }
        print("SENDING")
        WCSession.default.sendMessage(["message": message], replyHandler: nil) { error in
            print("Cannot send message: \(error)")
        }
        
        WCSession.default.sendMessage(["message": message], replyHandler: nil) { error in
            print("Cannot send message: \(error)")
        }
    }
}
