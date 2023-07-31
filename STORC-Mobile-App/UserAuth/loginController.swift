//
//  loginController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/12/23.
//

import UIKit
import SwiftUI
import WatchConnectivity

class loginController: UIViewController, WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let incomingDatapoint = message["message"] as? [Any]
        print(incomingDatapoint, " THIS IS MESSAGE")
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
//        if(HRData.isEmpty == true){
//            HRData.push(HeartRateDataPoint(heartRateValue: HR! as! Int, timeStamp: HRDate! as! Date))
//        }else{
//            HRData.append(HeartRateDataPoint(heartRateValue: HR! as! Int, timeStamp: HRDate! as! Date))
//        }

    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    let userInfo = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    //When user does not have account send them to sign up page
    @IBAction func sendToSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    //When submit button is pressed check conditions then send to main
    @IBAction func sendToMain(_ sender: UIButton) {
        let userName = userInfo.string(forKey: "Username")
        let userPass = userInfo.string(forKey: "Password")
        if(userName == usernameField.text && userPass == passwordField.text){
            self.performSegue(withIdentifier: "sendToMain", sender: self)
        }else{
            let alert = UIAlertController(title: "Login Failed", message: "Your password or username is not correct please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: {_ in NSLog("The \"OK\" alert occured.")}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
