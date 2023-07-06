//
//  WatchConnection.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/5/23.
//

import Foundation
import WatchConnectivity

struct notify: Identifiable {
    let id = UUID()
    let text : String
}

class WatchConnection: NSObject, ObservableObject {
    
    static let shared = WatchConnection()
    @Published var tempTemp: notify? = nil
    
    private override init(){
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func check(_ message: String){
        print("Do we enter here either?")
        #if os(iOS)
        if(WCSession.default.activationState == .activated && WCSession.default.isWatchAppInstalled == true){
            self.send(message)
        }
        #else
        if(WCSession.default.activationState == .activated && WCSession.default.isCompanionAppInstalled == true){
            self.send(message)
        }
        #endif
        self.send(message)
    }
    
    func send(_ message: String){
        print("Do we enter here to send the message")
        WCSession.default.sendMessage(["message": message], replyHandler: nil) { error in
            print("Cannot send message: \(error)")
        }
    }
}

extension WatchConnection: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("The session activated with activation state: \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let text = message["message"] as? String
        DispatchQueue.main.async {
            self.tempTemp = notify(text: text!)
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
