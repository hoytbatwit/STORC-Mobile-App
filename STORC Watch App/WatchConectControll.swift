//
//  WatchConectControll.swift
//  WatchApp WatchKit Extension
//
//  Created by Brian H on 8/3/23.
//

import Foundation
import WatchConnectivity

/**
 * This class manages the WCSession, allowing for communication between the iPhone and Apple Watch device.
 */
class WatchConectControll: NSObject, WCSessionDelegate{
    var session: WCSession
    init(session : WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        print("session is active")
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activatoinState: WCSessionActivationState, error: Error?){
    }
}
