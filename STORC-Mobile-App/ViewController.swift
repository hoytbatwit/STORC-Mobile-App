//
//  ViewController.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 6/9/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    //Working on timer stuff for manual contraction
    @State var timerRunning = false
    @State var ellapsedTime = 0
    var buttonState = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        
        timerRunning = true
    }
}

