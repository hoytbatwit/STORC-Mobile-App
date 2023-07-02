//
//  connectionController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 6/30/23.
//

import Foundation
import WatchConnectivity

class connectionController: NSObject, WCSessionDelegate {
    
    var session = WCSession.default
    
    override init(){
        super.init()
        
        if WCSession.isSupported(){
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation is completed with activation state \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session is inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session did deactivate going to reactivate")
        
        self.session.activate()
    }
    
    func session(_ session: WCSession, didReceive message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["message"] as? String == "Hello do you get this" {
            replyHandler(["test": "testing to see if this is the reply part"])
        }
    }
    
}
